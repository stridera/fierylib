"""
Binary plrmail parser for CircleMUD/FieryMUD mail format.

The legacy mail system uses a FAT-like block allocation scheme:
- BLOCK_SIZE = 100 bytes per block
- Messages start with a HeaderBlock, followed by zero or more DataBlocks
- Blocks are linked via next_block pointers

Block Types:
- HEADER_BLOCK (-1): Start of a mail message
- LAST_BLOCK (-2): Last block of a message chain
- DELETED_BLOCK (-3): Deleted/free block
- Positive values: Offset to next block in chain

32-bit format (legacy CircleMUD):
- long = 4 bytes
- sh_int = 2 bytes
- time_t = 4 bytes

HeaderBlock layout (100 bytes):
  - block_type: 4 bytes (always -1 for headers)
  - next_block: 4 bytes (offset to next block or -2 if last)
  - from: 4 bytes (sender player ID)
  - to: 4 bytes (recipient player ID)
  - vnum: 2 bytes (attached object VNUM, -1 for none)
  - mail_time: 4 bytes (Unix timestamp)
  - txt: 77 bytes + null terminator

DataBlock layout (100 bytes):
  - block_type: 4 bytes (-2 if last, or offset to next block)
  - txt: 95 bytes + null terminator
"""

import struct
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Iterator

# Block size constants
BLOCK_SIZE = 100

# Block type markers
HEADER_BLOCK = -1
LAST_BLOCK = -2
DELETED_BLOCK = -3

# Structure sizes for 32-bit legacy format
SIZEOF_LONG = 4
SIZEOF_SHORT = 2
SIZEOF_TIME_T = 4
SIZEOF_CHAR = 1

# Calculated data sizes
HEADER_DATA_SIZE = SIZEOF_LONG + SIZEOF_LONG + SIZEOF_LONG + SIZEOF_SHORT + SIZEOF_TIME_T  # 18 bytes
HEADER_BLOCK_DATASIZE = BLOCK_SIZE - SIZEOF_LONG - HEADER_DATA_SIZE - SIZEOF_CHAR  # 77 bytes
DATA_BLOCK_DATASIZE = BLOCK_SIZE - SIZEOF_LONG - SIZEOF_CHAR  # 95 bytes


@dataclass
class MailMessage:
    """Represents a parsed mail message from the binary format."""

    sender_id: int
    recipient_id: int
    mail_time: datetime
    attached_vnum: int | None  # -1 in legacy means no attachment
    body: str
    block_offset: int  # Starting block offset in file (for debugging)

    def __post_init__(self) -> None:
        # Convert -1 vnum to None for cleaner API
        if self.attached_vnum == -1:
            self.attached_vnum = None


def parse_plrmail(file_path: str | Path) -> Iterator[MailMessage]:
    """
    Parse a CircleMUD plrmail binary file and yield MailMessage objects.

    Args:
        file_path: Path to the plrmail binary file

    Yields:
        MailMessage objects for each valid (non-deleted) message
    """
    file_path = Path(file_path)

    if not file_path.exists():
        raise FileNotFoundError(f"Mail file not found: {file_path}")

    with open(file_path, "rb") as f:
        data = f.read()

    file_size = len(data)

    if file_size % BLOCK_SIZE != 0:
        raise ValueError(
            f"File size {file_size} is not a multiple of block size {BLOCK_SIZE}"
        )

    num_blocks = file_size // BLOCK_SIZE

    # Track which blocks we've processed (to avoid re-processing data blocks)
    processed_blocks: set[int] = set()

    for block_num in range(num_blocks):
        if block_num in processed_blocks:
            continue

        block_offset = block_num * BLOCK_SIZE
        block_data = data[block_offset : block_offset + BLOCK_SIZE]

        # Read block type (first 4 bytes as signed long)
        (block_type,) = struct.unpack("<l", block_data[0:4])

        # Skip non-header blocks (they're part of message chains or deleted)
        if block_type != HEADER_BLOCK:
            processed_blocks.add(block_num)
            continue

        # Parse header block
        message = _parse_header_block(block_data, data, block_offset, processed_blocks)
        if message:
            yield message


def _parse_header_block(
    block_data: bytes,
    file_data: bytes,
    block_offset: int,
    processed_blocks: set[int],
) -> MailMessage | None:
    """
    Parse a header block and follow the chain to extract the full message.

    Args:
        block_data: 100-byte header block
        file_data: Complete file data (for following block chains)
        block_offset: Offset of this block in the file
        processed_blocks: Set of already-processed block numbers

    Returns:
        MailMessage if valid, None if deleted or invalid
    """
    # Header block layout:
    # [0:4]   block_type (long) - should be -1
    # [4:8]   next_block (long) - offset to next block or -2
    # [8:12]  from (long) - sender player ID
    # [12:16] to (long) - recipient player ID
    # [16:18] vnum (short) - attached object VNUM
    # [18:22] mail_time (time_t) - Unix timestamp
    # [22:99] txt (77 bytes) - first part of message text
    # [99]    null terminator

    # Unpack header fields
    block_type, next_block, from_id, to_id, vnum, mail_time = struct.unpack(
        "<llllhl",  # 4 longs, 1 short, 1 long (for time_t)
        block_data[0:22],
    )

    # Extract text from header block (77 bytes after header data)
    header_text = block_data[22:99]

    # Find null terminator in text
    null_pos = header_text.find(b"\x00")
    if null_pos != -1:
        header_text = header_text[:null_pos]

    # Decode text (CircleMUD uses Latin-1/CP1252 typically)
    try:
        message_parts = [header_text.decode("latin-1")]
    except UnicodeDecodeError:
        message_parts = [header_text.decode("utf-8", errors="replace")]

    # Mark this block as processed
    processed_blocks.add(block_offset // BLOCK_SIZE)

    # Follow the chain if there are more blocks
    current_next = next_block
    while current_next != LAST_BLOCK and current_next > 0:
        # next_block is a file offset, not a block number
        if current_next >= len(file_data):
            break

        data_block = file_data[current_next : current_next + BLOCK_SIZE]
        if len(data_block) < BLOCK_SIZE:
            break

        # Mark as processed
        processed_blocks.add(current_next // BLOCK_SIZE)

        # DataBlock layout:
        # [0:4]   block_type (long) - next offset or -2 for last
        # [4:99]  txt (95 bytes) - message text
        # [99]    null terminator
        (data_block_type,) = struct.unpack("<l", data_block[0:4])

        data_text = data_block[4:99]
        null_pos = data_text.find(b"\x00")
        if null_pos != -1:
            data_text = data_text[:null_pos]

        try:
            message_parts.append(data_text.decode("latin-1"))
        except UnicodeDecodeError:
            message_parts.append(data_text.decode("utf-8", errors="replace"))

        # Follow to next block
        if data_block_type == LAST_BLOCK or data_block_type < 0:
            break
        current_next = data_block_type

    # Combine all text parts
    full_body = "".join(message_parts)

    # Convert timestamp to datetime
    try:
        mail_datetime = datetime.fromtimestamp(mail_time)
    except (ValueError, OSError):
        # Handle invalid timestamps
        mail_datetime = datetime.now()

    return MailMessage(
        sender_id=from_id,
        recipient_id=to_id,
        mail_time=mail_datetime,
        attached_vnum=vnum,
        body=full_body,
        block_offset=block_offset,
    )


def analyze_plrmail(file_path: str | Path) -> dict:
    """
    Analyze a plrmail file and return statistics.

    Args:
        file_path: Path to the plrmail binary file

    Returns:
        Dictionary with file statistics
    """
    file_path = Path(file_path)

    with open(file_path, "rb") as f:
        data = f.read()

    file_size = len(data)
    num_blocks = file_size // BLOCK_SIZE

    stats = {
        "file_size": file_size,
        "total_blocks": num_blocks,
        "header_blocks": 0,
        "data_blocks": 0,
        "deleted_blocks": 0,
        "unknown_blocks": 0,
        "messages": [],
    }

    for block_num in range(num_blocks):
        block_offset = block_num * BLOCK_SIZE
        block_data = data[block_offset : block_offset + BLOCK_SIZE]

        (block_type,) = struct.unpack("<l", block_data[0:4])

        if block_type == HEADER_BLOCK:
            stats["header_blocks"] += 1
        elif block_type == DELETED_BLOCK:
            stats["deleted_blocks"] += 1
        elif block_type == LAST_BLOCK or block_type > 0:
            stats["data_blocks"] += 1
        else:
            stats["unknown_blocks"] += 1

    # Count actual messages
    messages = list(parse_plrmail(file_path))
    stats["message_count"] = len(messages)

    return stats


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python plrmail_parser.py <plrmail_file>")
        sys.exit(1)

    mail_file = sys.argv[1]

    print(f"\nAnalyzing: {mail_file}")
    stats = analyze_plrmail(mail_file)
    print(f"File size: {stats['file_size']} bytes")
    print(f"Total blocks: {stats['total_blocks']}")
    print(f"Header blocks: {stats['header_blocks']}")
    print(f"Data blocks: {stats['data_blocks']}")
    print(f"Deleted blocks: {stats['deleted_blocks']}")
    print(f"Unknown blocks: {stats['unknown_blocks']}")
    print(f"Message count: {stats['message_count']}")

    print("\n--- Messages ---\n")
    for msg in parse_plrmail(mail_file):
        print(f"From: {msg.sender_id} -> To: {msg.recipient_id}")
        print(f"Date: {msg.mail_time}")
        if msg.attached_vnum:
            print(f"Attachment: Object #{msg.attached_vnum}")
        print(f"Body:\n{msg.body}")
        print("-" * 40)
