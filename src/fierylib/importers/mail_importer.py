"""
Mail Importer - Imports mail messages from legacy plrmail binary file to PostgreSQL

Handles:
- Parsing binary plrmail format (CircleMUD/FieryMUD)
- Converting legacy player IDs to modern character references (when possible)
- Storing attached object references with composite keys
"""

from datetime import datetime
from pathlib import Path
from typing import Any

from parsers.plrmail_parser import parse_plrmail, analyze_plrmail, MailMessage


class MailImporter:
    """Imports mail messages to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
        """
        Initialize mail importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client

    def _vnum_to_composite(self, vnum: int | None) -> tuple[int | None, int | None]:
        """
        Convert a legacy VNUM to (zone_id, local_id) tuple

        Args:
            vnum: Legacy VNUM (e.g., 3045 = zone 30, object 45)

        Returns:
            Tuple of (zone_id, local_id) or (None, None)
        """
        if vnum is None or vnum < 0:
            return None, None
        zone_id = vnum // 100 if vnum >= 100 else 1000  # Zone 0 -> 1000
        local_id = vnum % 100
        return zone_id, local_id

    async def import_mail(
        self,
        mail_message: MailMessage,
        dry_run: bool = False,
    ) -> dict[str, Any]:
        """
        Import a single mail message

        Args:
            mail_message: Parsed MailMessage from binary file
            dry_run: If True, don't actually write to database

        Returns:
            dict with import statistics
        """
        stats: dict[str, Any] = {
            "imported": 0,
            "skipped": 0,
        }

        # Convert attached object VNUM to composite key
        attached_zone_id, attached_object_id = self._vnum_to_composite(
            mail_message.attached_vnum
        )

        # Validate attached object exists (if any)
        if attached_zone_id is not None and attached_object_id is not None:
            obj_exists = await self.prisma.objects.find_first(
                where={"zoneId": attached_zone_id, "id": attached_object_id}
            )
            if not obj_exists:
                # Object doesn't exist, clear the attachment
                attached_zone_id = None
                attached_object_id = None

        # Prepare mail data
        # Store legacy numeric player IDs - these will be remapped to character UUIDs
        # after character import via a separate migration script
        mail_data = {
            # Legacy IDs (numeric player IDs from CircleMUD)
            "legacySenderId": mail_message.sender_id,
            "legacyRecipientId": mail_message.recipient_id,
            # Character IDs are null until remapped after character import
            "senderCharacterId": None,
            "recipientCharacterId": None,
            # Mail content
            "body": mail_message.body,
            "sentAt": mail_message.mail_time,
            # Wealth attachments - legacy format doesn't have wealth
            "attachedCopper": 0,
            "attachedSilver": 0,
            "attachedGold": 0,
            "attachedPlatinum": 0,
            # Object attachment
            "attachedObjectZoneId": attached_zone_id,
            "attachedObjectId": attached_object_id,
            # Retrieval tracking - not retrieved yet
            "wealthRetrievedAt": None,
            "wealthRetrievedByCharacterId": None,
            "objectRetrievedAt": None,
            "objectRetrievedByCharacterId": None,
            "objectMovedToAccountStorage": False,
            # Status
            "isDeleted": False,
        }

        if not dry_run:
            await self.prisma.playermail.create(data=mail_data)

        stats["imported"] = 1
        return stats

    async def import_from_file(
        self,
        file_path: str | Path,
        dry_run: bool = False,
        verbose: bool = False,
    ) -> dict[str, Any]:
        """
        Import all mail messages from a plrmail binary file

        Args:
            file_path: Path to the plrmail binary file
            dry_run: If True, don't actually write to database
            verbose: If True, print details for each message

        Returns:
            dict with total import statistics
        """
        file_path = Path(file_path)

        if not file_path.exists():
            raise FileNotFoundError(f"Mail file not found: {file_path}")

        # Get file stats first
        file_stats = analyze_plrmail(file_path)

        total_stats: dict[str, Any] = {
            "total_blocks": file_stats["total_blocks"],
            "header_blocks": file_stats["header_blocks"],
            "deleted_blocks": file_stats["deleted_blocks"],
            "imported": 0,
            "skipped": 0,
            "errors": 0,
            "with_attachments": 0,
        }

        # Clear existing mail if not dry run
        if not dry_run:
            deleted = await self.prisma.playermail.delete_many()
            if verbose:
                print(f"Cleared {deleted} existing mail records")

        # Import each message
        for mail_message in parse_plrmail(file_path):
            try:
                if verbose:
                    print(
                        f"  Importing: {mail_message.sender_id} -> {mail_message.recipient_id} "
                        f"({mail_message.mail_time.strftime('%Y-%m-%d %H:%M')})"
                    )

                stats = await self.import_mail(mail_message, dry_run=dry_run)
                total_stats["imported"] += stats.get("imported", 0)
                total_stats["skipped"] += stats.get("skipped", 0)

                if mail_message.attached_vnum:
                    total_stats["with_attachments"] += 1

            except Exception as e:
                print(f"  Error importing mail: {e}")
                total_stats["errors"] += 1

        return total_stats


async def import_mail_cli(
    prisma_client,
    file_path: str,
    dry_run: bool = False,
    verbose: bool = False,
) -> dict[str, Any]:
    """
    CLI entry point for mail import

    Args:
        prisma_client: Prisma client instance
        file_path: Path to plrmail binary file
        dry_run: If True, don't write to database
        verbose: If True, print details

    Returns:
        Import statistics
    """
    importer = MailImporter(prisma_client)
    return await importer.import_from_file(file_path, dry_run=dry_run, verbose=verbose)
