"""
Mail Importer - Imports mail messages from legacy plrmail binary file to PostgreSQL

Handles:
- Parsing binary plrmail format (CircleMUD/FieryMUD)
- Resolving legacy player IDs to character UUIDs via in-memory mapping from player import
- Storing attached object references with composite keys
"""

from pathlib import Path
from typing import Any

from parsers.plrmail_parser import parse_plrmail, analyze_plrmail, MailMessage
from fierylib.converters import EntityResolver


class MailImporter:
    """Imports mail messages to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
        """
        Initialize mail importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client
        self.resolver = EntityResolver(prisma_client)

    async def import_mail(
        self,
        mail_message: MailMessage,
        legacy_to_char: dict[int, str],
        dry_run: bool = False,
    ) -> dict[str, Any]:
        """
        Import a single mail message

        Args:
            mail_message: Parsed MailMessage from binary file
            legacy_to_char: Mapping from legacy player ID to character UUID
            dry_run: If True, don't actually write to database

        Returns:
            dict with import statistics
        """
        stats: dict[str, Any] = {
            "imported": 0,
            "skipped": 0,
        }

        # Resolve attached object VNUM to composite key using EntityResolver
        attached_zone_id = None
        attached_object_id = None

        if mail_message.attached_vnum is not None and mail_message.attached_vnum >= 0:
            vnum = mail_message.attached_vnum
            context_zone = vnum // 100 if vnum >= 100 else 0
            obj_result = await self.resolver.resolve_object(vnum, context_zone=context_zone)

            if obj_result:
                attached_zone_id = obj_result.zone_id
                attached_object_id = obj_result.id

        # Resolve sender/recipient legacy IDs to character UUIDs
        sender_char_id = legacy_to_char.get(mail_message.sender_id)
        recipient_char_id = legacy_to_char.get(mail_message.recipient_id)

        mail_data = {
            # Legacy IDs (numeric player IDs from CircleMUD)
            "legacySenderId": mail_message.sender_id,
            "legacyRecipientId": mail_message.recipient_id,
            # Resolved character IDs (null if character was deleted/not imported)
            "senderCharacterId": sender_char_id,
            "recipientCharacterId": recipient_char_id,
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
        legacy_to_char: dict[int, str] | None = None,
        dry_run: bool = False,
        verbose: bool = False,
    ) -> dict[str, Any]:
        """
        Import all mail messages from a plrmail binary file

        Args:
            file_path: Path to the plrmail binary file
            legacy_to_char: Mapping from legacy player ID to character UUID
                           (from player import). If None, sender/recipient
                           character IDs will be null.
            dry_run: If True, don't actually write to database
            verbose: If True, print details for each message

        Returns:
            dict with total import statistics
        """
        file_path = Path(file_path)

        if not file_path.exists():
            raise FileNotFoundError(f"Mail file not found: {file_path}")

        if legacy_to_char is None:
            legacy_to_char = {}

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
            "senders_resolved": 0,
            "recipients_resolved": 0,
        }

        if verbose:
            print(f"  Legacy ID lookup has {len(legacy_to_char)} characters")

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

                stats = await self.import_mail(mail_message, legacy_to_char, dry_run=dry_run)
                total_stats["imported"] += stats.get("imported", 0)
                total_stats["skipped"] += stats.get("skipped", 0)

                if mail_message.sender_id in legacy_to_char:
                    total_stats["senders_resolved"] += 1
                if mail_message.recipient_id in legacy_to_char:
                    total_stats["recipients_resolved"] += 1

                if mail_message.attached_vnum:
                    total_stats["with_attachments"] += 1

            except Exception as e:
                print(f"  Error importing mail: {e}")
                total_stats["errors"] += 1

        return total_stats


async def import_mail_cli(
    prisma_client,
    file_path: str,
    legacy_to_char: dict[int, str] | None = None,
    dry_run: bool = False,
    verbose: bool = False,
) -> dict[str, Any]:
    """
    CLI entry point for mail import

    Args:
        prisma_client: Prisma client instance
        file_path: Path to plrmail binary file
        legacy_to_char: Mapping from legacy player ID to character UUID
        dry_run: If True, don't write to database
        verbose: If True, print details

    Returns:
        Import statistics
    """
    importer = MailImporter(prisma_client)
    return await importer.import_from_file(
        file_path, legacy_to_char=legacy_to_char, dry_run=dry_run, verbose=verbose
    )
