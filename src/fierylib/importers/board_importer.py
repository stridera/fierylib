"""Import bulletin boards from FieryMUD board files into the database."""

import json
import click
import asyncio
from pathlib import Path
from typing import Dict, Optional
from prisma import Prisma

from ..parsers.board_parser import BoardParser, parse_all_boards, BoardData
from ..converters.color_converter import convert_legacy_colors


class BoardImporter:
    """Import bulletin boards from .brd files."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma
        self.stats = {
            "boards_created": 0,
            "boards_updated": 0,
            "messages_created": 0,
            "messages_skipped": 0,
            "edits_created": 0,
            "errors": 0,
        }

    async def import_boards(
        self,
        boards_dir: Path,
        verbose: bool = False,
        clear_existing: bool = False,
    ) -> Dict[str, int]:
        """Import all boards from a directory.

        Args:
            boards_dir: Directory containing .brd files and index
            verbose: Show detailed output
            clear_existing: Delete all existing boards before import

        Returns:
            Dictionary with import statistics
        """

        if clear_existing:
            click.echo("  Clearing existing board data...")
            # Delete in order: edits -> messages -> boards
            await self.prisma.boardmessageedit.delete_many()
            await self.prisma.boardmessage.delete_many()
            deleted = await self.prisma.board.delete_many()
            click.echo(f"  Deleted {deleted} boards")

        click.echo(f"\nParsing board files from {boards_dir}...")
        boards = parse_all_boards(boards_dir)
        total_messages = sum(len(b.messages) for b in boards)
        click.echo(f"  Found {len(boards)} boards with {total_messages} messages")

        click.echo("\nImporting boards...")

        for board in boards:
            try:
                await self._import_board(board, verbose)
            except Exception as e:
                self.stats["errors"] += 1
                click.echo(f"  Error importing board '{board.alias}': {e}")

        return self.stats

    async def _import_board(self, board_data: BoardData, verbose: bool):
        """Import a single board and its messages."""

        # Build privilege JSON (8 privilege levels)
        privileges = board_data.privileges if board_data.privileges else []

        # Check if board exists
        existing = await self.prisma.board.find_unique(
            where={"alias": board_data.alias}
        )

        if existing:
            # Update board metadata
            db_board = await self.prisma.board.update(
                where={"alias": board_data.alias},
                data={
                    "title": board_data.title,
                    "privileges": json.dumps(privileges),
                },
            )
            self.stats["boards_updated"] += 1
            if verbose:
                click.echo(f"  Updated board: {board_data.alias}")
        else:
            # Create new board
            db_board = await self.prisma.board.create(
                data={
                    "alias": board_data.alias,
                    "title": board_data.title,
                    "privileges": json.dumps(privileges),
                    "locked": False,
                }
            )
            self.stats["boards_created"] += 1
            if verbose:
                click.echo(f"  Created board: {board_data.alias}")

        # Import messages
        for msg in board_data.messages:
            try:
                await self._import_message(db_board.id, msg, verbose)
            except Exception as e:
                self.stats["errors"] += 1
                if verbose:
                    click.echo(f"    Error importing message '{msg.subject[:30]}...': {e}")

    async def _import_message(self, board_id: int, msg, verbose: bool):
        """Import a single board message."""

        # Convert legacy color codes in content
        content = convert_legacy_colors(msg.content)

        # Check if message already exists (by poster, subject, and posted time)
        existing = await self.prisma.boardmessage.find_first(
            where={
                "boardId": board_id,
                "poster": msg.poster,
                "subject": msg.subject,
                "postedAt": msg.posted_at,
            }
        )

        if existing:
            self.stats["messages_skipped"] += 1
            return

        # Create message
        db_message = await self.prisma.boardmessage.create(
            data={
                "boardId": board_id,
                "poster": msg.poster,
                "posterLevel": msg.poster_level,
                "postedAt": msg.posted_at,
                "subject": msg.subject,
                "content": content,
                "sticky": msg.sticky,
            }
        )
        self.stats["messages_created"] += 1

        if verbose:
            click.echo(f"    Message: {msg.subject[:50]}... by {msg.poster}")

        # Import edits
        for edit in msg.edits:
            await self.prisma.boardmessageedit.create(
                data={
                    "messageId": db_message.id,
                    "editor": edit.editor,
                    "editedAt": edit.edited_at,
                }
            )
            self.stats["edits_created"] += 1


async def import_boards(
    boards_dir: Path,
    verbose: bool = False,
    clear_existing: bool = False,
) -> Dict[str, int]:
    """Main entry point for importing boards."""
    prisma = Prisma()
    await prisma.connect()

    try:
        importer = BoardImporter(prisma)
        return await importer.import_boards(boards_dir, verbose, clear_existing)
    finally:
        await prisma.disconnect()


@click.command(name="boards")
@click.option("--verbose", "-v", is_flag=True, help="Show detailed output")
@click.option("--clear", is_flag=True, help="Clear existing boards before import")
@click.argument("boards_dir", type=click.Path(exists=True), required=False)
def import_boards_cli(verbose: bool, clear: bool, boards_dir: Optional[str]):
    """Import bulletin boards from FieryMUD board files.

    BOARDS_DIR: Path to directory containing .brd board files
    (default: fierymud/legacy/lib/etc/boards/)
    """

    # Default boards directory
    if boards_dir is None:
        default_paths = [
            Path("/home/strider/Code/mud/fierymud/legacy/lib/etc/boards"),
            Path("../fierymud/legacy/lib/etc/boards"),
        ]
        for p in default_paths:
            if p.exists():
                boards_dir = str(p)
                break

    if boards_dir is None:
        click.echo("Error: Could not find boards directory. Please specify path.")
        return

    async def run():
        click.echo("=" * 60)
        click.echo("Importing Bulletin Boards")
        click.echo("=" * 60)

        stats = await import_boards(
            Path(boards_dir), verbose, clear
        )

        click.echo("\n" + "=" * 60)
        click.echo("Import Summary")
        click.echo("=" * 60)
        click.echo(f"  Boards created:   {stats['boards_created']}")
        click.echo(f"  Boards updated:   {stats['boards_updated']}")
        click.echo(f"  Messages created: {stats['messages_created']}")
        click.echo(f"  Messages skipped: {stats['messages_skipped']}")
        click.echo(f"  Edits created:    {stats['edits_created']}")
        if stats['errors'] > 0:
            click.echo(f"  Errors:           {stats['errors']}")
        else:
            click.echo(f"  Errors:           0")
        click.echo("\nImport complete!")

    asyncio.run(run())


if __name__ == "__main__":
    import_boards_cli()
