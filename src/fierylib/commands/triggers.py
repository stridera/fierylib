"""
Trigger CLI commands - Convert legacy DG scripts and manage Lua triggers

This module contains the one-time legacy conversion tool. The convert-legacy
command should only be run once to migrate from DG scripts to Lua files.
Future imports should use the generated Lua files directly.
"""

import re
import click
from pathlib import Path


@click.group()
def triggers():
    """Trigger management commands"""
    pass


def sanitize_filename(name: str) -> str:
    """Convert trigger name to safe filename component."""
    # Replace spaces and special chars with underscores
    safe = re.sub(r'[^a-zA-Z0-9_-]', '_', name.lower())
    # Collapse multiple underscores
    safe = re.sub(r'_+', '_', safe)
    # Trim underscores from ends
    safe = safe.strip('_')
    return safe[:50] if safe else "unnamed"


def detect_issues_from_lua(commands: str, syntax_error: str | None = None) -> list[str]:
    """
    Detect issues in Lua code that require review.

    Returns list of issue descriptions.
    """
    issues = []

    # Check for UNCONVERTED markers
    if "-- UNCONVERTED" in commands:
        unconverted_matches = re.findall(r'-- UNCONVERTED[^\n]*', commands)
        for match in unconverted_matches[:3]:  # Limit to first 3
            issues.append(match.strip())

    # Check for TODO markers
    if "-- TODO" in commands:
        todo_matches = re.findall(r'-- TODO[^\n]*', commands)
        for match in todo_matches[:2]:  # Limit to first 2
            issues.append(match.strip())

    # Check syntax error
    if syntax_error:
        issues.append(f"Syntax error: {syntax_error[:100]}")

    # Check for complex nesting (count levels of 'if' vs 'end')
    if_count = len(re.findall(r'\bif\b', commands))
    if if_count > 5:
        issues.append(f"Complex nesting: {if_count} if statements")

    # Check file size (complexity indicator)
    if len(commands) > 5000:
        issues.append(f"Large script: {len(commands)} chars")

    return issues


def format_flags(flags: list) -> str:
    """Format trigger flags for display."""
    if not flags:
        return ""
    return ", ".join(str(f) for f in flags)


def generate_lua_file_content(
    lua_trigger,
    issues: list[str],
    original_vnum: int
) -> str:
    """Generate the Lua file content with header comments."""
    lines = []

    # Header block
    lines.append(f"-- Trigger: {lua_trigger.name}")
    lines.append(f"-- Zone: {lua_trigger.zone_id}, ID: {lua_trigger.local_id}")
    lines.append(f"-- Type: {lua_trigger.attach_type}, Flags: {format_flags(lua_trigger.flags)}")

    # Status based on issues
    if issues:
        lines.append(f"-- Status: NEEDS_REVIEW")
        for issue in issues:
            lines.append(f"--   {issue}")
    else:
        lines.append(f"-- Status: CLEAN")

    lines.append(f"--")
    lines.append(f"-- Original DG Script: #{original_vnum}")
    lines.append("")

    # The actual Lua code
    lines.append(lua_trigger.commands or "-- (empty trigger)")

    return "\n".join(lines)


def generate_review_status_md(
    triggers_by_zone: dict,
    needs_review: list,
    clean: list
) -> str:
    """Generate the REVIEW_STATUS.md content."""
    lines = []

    total = sum(len(t) for t in triggers_by_zone.values())
    review_count = len(needs_review)
    clean_count = len(clean)

    # Header
    lines.append("# Trigger Review Status")
    lines.append("")
    lines.append("## Summary")
    lines.append(f"- Total: {total} triggers")
    lines.append(f"- Clean: {clean_count} ({100*clean_count/total:.1f}%)" if total else "- Clean: 0")
    lines.append(f"- Needs Review: {review_count} ({100*review_count/total:.1f}%)" if total else "- Needs Review: 0")
    lines.append("- Reviewed: 0")
    lines.append("")

    # Needs Review section
    lines.append("## Needs Review")
    lines.append("")
    if needs_review:
        lines.append("| Zone | ID | Name | Issue |")
        lines.append("|------|-----|------|-------|")
        for trigger, issue_list in needs_review:
            issue_str = issue_list[0] if issue_list else "Unknown"
            # Escape pipe characters in issue string
            issue_str = issue_str.replace("|", "\\|")[:80]
            lines.append(f"| {trigger.zone_id} | {trigger.local_id} | {trigger.name[:30]} | {issue_str} |")
    else:
        lines.append("(none)")
    lines.append("")

    # Clean section (abbreviated)
    lines.append("## Clean (Auto-converted OK)")
    lines.append("")
    if clean:
        lines.append("| Zone | ID | Name |")
        lines.append("|------|-----|------|")
        # Show first 50 and last 10
        shown = clean[:50]
        if len(clean) > 60:
            shown.append(None)  # Marker for "..."
            shown.extend(clean[-10:])

        for trigger in shown:
            if trigger is None:
                lines.append(f"| ... | ... | ({len(clean) - 60} more) |")
            else:
                lines.append(f"| {trigger.zone_id} | {trigger.local_id} | {trigger.name[:30]} |")
    else:
        lines.append("(none)")
    lines.append("")

    # Reviewed section (placeholder)
    lines.append("## Reviewed & Approved")
    lines.append("")
    lines.append("| Zone | ID | Name | Reviewed By | Date |")
    lines.append("|------|-----|------|-------------|------|")
    lines.append("| (none yet) |  |  |  |  |")
    lines.append("")

    return "\n".join(lines)


@triggers.command(name="convert-legacy")
@click.option(
    "--lib-path",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=None,
    help="Path to legacy CircleMUD lib directory (default: LEGACY_LIB_PATH env or ../lib)",
)
@click.option(
    "--output",
    type=click.Path(file_okay=False, dir_okay=True),
    default=None,
    help="Output directory for Lua files (default: {lib-path}/../lib/triggers)",
)
@click.option(
    "--verbose",
    "-v",
    is_flag=True,
    default=False,
    help="Show detailed output",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Show what would be converted without writing files",
)
@click.option(
    "--validate-syntax",
    is_flag=True,
    default=True,
    help="Validate Lua syntax using luac (default: True)",
)
def convert_legacy(
    lib_path: str | None,
    output: str | None,
    verbose: bool,
    dry_run: bool,
    validate_syntax: bool
):
    """
    Convert legacy DG Script triggers to Lua files.

    THIS IS A ONE-TIME MIGRATION TOOL. Run this once to convert all DG scripts
    to Lua files for curation. Future imports should use the generated files.

    Reads from: {lib-path}/world/trg/*.trg
    Writes to:  {output}/{zone_id}/{zone_id}_{id}_{name}.lua

    Example:
        fierylib triggers convert-legacy --lib-path ../fierymud_legacy/lib
    """
    import os
    import subprocess
    import tempfile

    from fierylib.parsers.trigger_parser import parse_all_triggers
    from fierylib.converters.dg_to_lua import convert_trigger

    # Resolve lib path
    if lib_path is None:
        lib_path = os.getenv("LEGACY_LIB_PATH", "../lib")
    lib_path = Path(lib_path)

    # Resolve output path
    if output is None:
        # Default to fierylib/data/triggers
        output = Path(__file__).parent.parent.parent.parent / "data" / "triggers"
    output_path = Path(output)

    click.echo("=" * 60)
    click.echo("FieryLib DG Script → Lua Converter")
    click.echo("=" * 60)
    click.echo("")
    click.echo("WARNING: This is a ONE-TIME migration tool.")
    click.echo("Run this once to convert DG scripts to Lua files.")
    click.echo("Future imports will use the generated Lua files.")
    click.echo("")
    click.echo(f"Source: {lib_path.absolute()}/world/trg/")
    click.echo(f"Output: {output_path.absolute()}/")

    if dry_run:
        click.echo("\nDRY RUN - No files will be written")

    # Check source directory exists
    trg_dir = lib_path / "world" / "trg"
    if not trg_dir.exists():
        click.echo(f"\nError: Trigger directory not found: {trg_dir}")
        return

    # Parse all DG triggers
    click.echo(f"\nParsing DG Script files...")
    dg_triggers = parse_all_triggers(trg_dir)
    click.echo(f"Found {len(dg_triggers)} triggers in {len(list(trg_dir.glob('*.trg')))} files")

    if not dg_triggers:
        click.echo("No triggers to convert.")
        return

    # Helper to validate Lua syntax
    def validate_lua(code: str, name: str) -> tuple[bool, str]:
        if not validate_syntax:
            return True, ""
        with tempfile.NamedTemporaryFile(mode='w', suffix='.lua', delete=False) as f:
            f.write(code)
            temp_path = f.name
        try:
            result = subprocess.run(
                ['luac', '-p', temp_path],
                capture_output=True,
                text=True
            )
            if result.returncode != 0:
                error = result.stderr.strip()
                error = error.replace(temp_path, f'<{name}>')
                return False, error
            return True, ""
        except FileNotFoundError:
            return True, ""  # luac not installed
        finally:
            os.unlink(temp_path)

    # Convert all triggers
    click.echo(f"\nConverting to Lua...")

    triggers_by_zone: dict[int, list] = {}
    needs_review: list[tuple] = []
    clean: list = []
    conversion_errors = 0

    for dg_trigger in dg_triggers:
        try:
            lua_trigger = convert_trigger(dg_trigger)

            # Validate syntax
            syntax_valid, syntax_error = validate_lua(lua_trigger.commands, lua_trigger.name)

            # Detect issues
            issues = detect_issues_from_lua(
                lua_trigger.commands,
                syntax_error if not syntax_valid else None
            )

            # Organize by zone
            zone_id = lua_trigger.zone_id
            if zone_id not in triggers_by_zone:
                triggers_by_zone[zone_id] = []
            triggers_by_zone[zone_id].append((lua_trigger, dg_trigger.vnum, issues))

            if issues:
                needs_review.append((lua_trigger, issues))
            else:
                clean.append(lua_trigger)

        except Exception as e:
            conversion_errors += 1
            if verbose:
                click.echo(f"  Error converting #{dg_trigger.vnum} ({dg_trigger.name}): {e}")

    click.echo(f"\nConversion complete:")
    click.echo(f"  Zones: {len(triggers_by_zone)}")
    click.echo(f"  Clean: {len(clean)}")
    click.echo(f"  Needs review: {len(needs_review)}")
    if conversion_errors:
        click.echo(f"  Errors: {conversion_errors}")

    if dry_run:
        click.echo("\n--- DRY RUN: Would create the following structure ---")
        for zone_id in sorted(triggers_by_zone.keys()):
            zone_triggers = triggers_by_zone[zone_id]
            click.echo(f"\n{output_path}/{zone_id:03d}/")
            for lua_trigger, vnum, issues in zone_triggers[:5]:
                safe_name = sanitize_filename(lua_trigger.name)
                filename = f"{zone_id:03d}_{lua_trigger.local_id:02d}_{safe_name}.lua"
                status = "[REVIEW]" if issues else "[CLEAN]"
                click.echo(f"  {status} {filename}")
            if len(zone_triggers) > 5:
                click.echo(f"  ... and {len(zone_triggers) - 5} more")
        click.echo(f"\n{output_path}/REVIEW_STATUS.md")
        return

    # Create output directory
    output_path.mkdir(parents=True, exist_ok=True)

    # Write trigger files
    files_written = 0
    click.echo(f"\nWriting Lua files...")

    for zone_id in sorted(triggers_by_zone.keys()):
        zone_triggers = triggers_by_zone[zone_id]
        zone_dir = output_path / f"{zone_id:03d}"
        zone_dir.mkdir(exist_ok=True)

        for lua_trigger, original_vnum, issues in zone_triggers:
            safe_name = sanitize_filename(lua_trigger.name)
            filename = f"{zone_id:03d}_{lua_trigger.local_id:02d}_{safe_name}.lua"
            file_path = zone_dir / filename

            content = generate_lua_file_content(lua_trigger, issues, original_vnum)
            file_path.write_text(content, encoding="utf-8")
            files_written += 1

            if verbose:
                status = "REVIEW" if issues else "CLEAN"
                click.echo(f"  [{status}] {file_path.relative_to(output_path)}")

        if not verbose:
            click.echo(f"  Zone {zone_id:03d}: {len(zone_triggers)} triggers")

    # Generate REVIEW_STATUS.md
    review_md = generate_review_status_md(triggers_by_zone, needs_review, clean)
    review_path = output_path / "REVIEW_STATUS.md"
    review_path.write_text(review_md, encoding="utf-8")

    click.echo(f"\n{'='*60}")
    click.echo(f"Conversion Complete")
    click.echo(f"{'='*60}")
    click.echo(f"Files written: {files_written}")
    click.echo(f"Zones: {len(triggers_by_zone)}")
    click.echo(f"Review status: {review_path}")

    if needs_review:
        click.echo(f"\nTriggers needing review: {len(needs_review)}")
        click.echo("See REVIEW_STATUS.md for details.")

    click.echo(f"\nNext steps:")
    click.echo(f"  1. Review/edit triggers in {output_path}/")
    click.echo(f"  2. Run 'fierylib import-legacy' to import from data/triggers/")
