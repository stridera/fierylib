"""Parser for FieryMUD board files (.brd)."""

import re
from pathlib import Path
from typing import List, Optional
from dataclasses import dataclass, field
from datetime import datetime


@dataclass
class BoardMessageEdit:
    """Represents an edit record for a board message."""
    editor: str
    edited_at: datetime


@dataclass
class BoardMessageData:
    """Represents a parsed board message."""
    poster: str
    poster_level: int
    posted_at: datetime
    subject: str
    content: str
    sticky: bool = False
    edits: List[BoardMessageEdit] = field(default_factory=list)


@dataclass
class BoardData:
    """Represents a parsed board."""
    number: int
    alias: str
    title: str
    privileges: List[int] = field(default_factory=list)  # List of privilege level requirements
    messages: List[BoardMessageData] = field(default_factory=list)


class BoardParser:
    """Parser for FieryMUD .brd board files.

    Board file format:
    ```
    number: <id>
    alias: <alias>
    title: <title>
    privilege: <level>  (repeated 0-8 times)
    ~~
    level: <poster_level>
    poster: <name>
    time: <unix_timestamp>
    sticky: 1  (optional)
    edit: <editor> <timestamp>  (optional, repeating)
    subject: <subject>
    message:
    <body text>
    ~
    ~~
    ```
    """

    def __init__(self):
        self.boards: List[BoardData] = []

    def parse_file(self, filepath: Path) -> Optional[BoardData]:
        """Parse a single board file."""

        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            content = f.read()

        # Split header from messages by ~~
        parts = content.split('~~')
        if len(parts) < 1:
            return None

        # Parse header (first part)
        header = parts[0].strip()
        board = self._parse_header(header)
        if not board:
            return None

        # Parse messages (remaining parts, pairs of content + ~~)
        message_parts = parts[1:]  # Skip header
        for i, msg_content in enumerate(message_parts):
            msg_content = msg_content.strip()
            if not msg_content:
                continue

            message = self._parse_message(msg_content)
            if message:
                board.messages.append(message)

        self.boards.append(board)
        return board

    def _parse_header(self, header: str) -> Optional[BoardData]:
        """Parse board header section."""

        number = None
        alias = None
        title = None
        privileges = []

        for line in header.split('\n'):
            line = line.strip()
            if not line:
                continue

            if line.startswith('number:'):
                try:
                    number = int(line.split(':', 1)[1].strip())
                except ValueError:
                    pass
            elif line.startswith('alias:'):
                alias = line.split(':', 1)[1].strip()
            elif line.startswith('title:'):
                title = line.split(':', 1)[1].strip()
            elif line.startswith('privilege:'):
                try:
                    priv_val = int(line.split(':', 1)[1].strip())
                    privileges.append(priv_val)
                except ValueError:
                    pass

        if number is None or alias is None:
            return None

        return BoardData(
            number=number,
            alias=alias,
            title=title or alias.title(),
            privileges=privileges,
        )

    def _parse_message(self, content: str) -> Optional[BoardMessageData]:
        """Parse a single board message."""

        # The message format has metadata lines followed by "message:" and content ending with ~
        poster = None
        poster_level = 0
        posted_at = None
        subject = None
        sticky = False
        edits = []
        body_lines = []

        lines = content.split('\n')
        in_body = False

        for line in lines:
            # Check for end of message body
            if in_body:
                if line.rstrip() == '~':
                    # End of message body
                    break
                body_lines.append(line)
                continue

            # Parse metadata lines
            stripped = line.strip()

            if stripped.startswith('level:'):
                try:
                    poster_level = int(stripped.split(':', 1)[1].strip())
                except ValueError:
                    pass
            elif stripped.startswith('poster:'):
                poster = stripped.split(':', 1)[1].strip()
            elif stripped.startswith('time:'):
                try:
                    timestamp = int(stripped.split(':', 1)[1].strip())
                    posted_at = datetime.fromtimestamp(timestamp)
                except (ValueError, OSError):
                    posted_at = datetime.now()
            elif stripped.startswith('subject:'):
                subject = stripped.split(':', 1)[1].strip()
            elif stripped.startswith('sticky:'):
                sticky = stripped.split(':', 1)[1].strip() == '1'
            elif stripped.startswith('edit:'):
                # Format: "edit: <name> <timestamp>"
                edit_data = stripped.split(':', 1)[1].strip()
                edit_parts = edit_data.rsplit(' ', 1)  # Split from right to get name and timestamp
                if len(edit_parts) == 2:
                    try:
                        edit_time = datetime.fromtimestamp(int(edit_parts[1]))
                        edits.append(BoardMessageEdit(editor=edit_parts[0], edited_at=edit_time))
                    except (ValueError, OSError):
                        pass
            elif stripped == 'message:':
                in_body = True

        if not poster or not subject:
            return None

        # Clean up body - join lines and handle color codes
        body = '\n'.join(body_lines)
        # Convert legacy color codes (&0, &1, etc.) if needed
        # For now, preserve them as-is for import

        return BoardMessageData(
            poster=poster,
            poster_level=poster_level,
            posted_at=posted_at or datetime.now(),
            subject=subject,
            content=body,
            sticky=sticky,
            edits=edits,
        )


def parse_all_boards(boards_dir: Path) -> List[BoardData]:
    """Parse all .brd files in a directory, using the index file."""

    parser = BoardParser()
    index_file = boards_dir / 'index'

    if index_file.exists():
        # Use index file to determine which boards to load
        with open(index_file, 'r') as f:
            for line in f:
                alias = line.strip()
                if not alias:
                    continue
                board_file = boards_dir / f'{alias}.brd'
                if board_file.exists():
                    parser.parse_file(board_file)
    else:
        # Fall back to loading all .brd files
        for brd_file in boards_dir.glob('*.brd'):
            parser.parse_file(brd_file)

    return parser.boards


# CLI testing
if __name__ == '__main__':
    import sys

    if len(sys.argv) < 2:
        print("Usage: python board_parser.py <boards_directory>")
        sys.exit(1)

    boards_path = Path(sys.argv[1])

    if boards_path.is_file():
        # Single file
        parser = BoardParser()
        board = parser.parse_file(boards_path)
        if board:
            print(f"Board: {board.alias} ({board.title})")
            print(f"  Number: {board.number}")
            print(f"  Privileges: {board.privileges}")
            print(f"  Messages: {len(board.messages)}")
            for i, msg in enumerate(board.messages[:3]):
                print(f"\n  [{i+1}] {msg.subject}")
                print(f"      By: {msg.poster} (level {msg.poster_level})")
                print(f"      Posted: {msg.posted_at}")
                print(f"      Sticky: {msg.sticky}")
                if msg.edits:
                    print(f"      Edits: {len(msg.edits)}")
                preview = msg.content[:100].replace('\n', ' ')
                print(f"      Content: {preview}...")
    else:
        # Directory
        boards = parse_all_boards(boards_path)
        print(f"Parsed {len(boards)} boards")

        total_messages = sum(len(b.messages) for b in boards)
        print(f"Total messages: {total_messages}")

        for board in boards:
            print(f"\n=== {board.alias} ({board.title}) ===")
            print(f"  Number: {board.number}")
            print(f"  Messages: {len(board.messages)}")
