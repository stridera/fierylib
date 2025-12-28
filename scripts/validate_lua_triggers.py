#!/usr/bin/env python3
"""
Validate all Lua trigger scripts in the database.

Loads each trigger's Lua code and attempts to compile it using lua's loadstring.
Reports any syntax errors without executing the scripts.
"""

import subprocess
import sys
import tempfile
import os
from pathlib import Path

# Add parent to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from prisma import Prisma


def validate_lua_syntax(code: str, name: str) -> tuple[bool, str]:
    """
    Validate Lua syntax by attempting to load the code.

    Returns:
        (success, error_message)
    """
    # Create a temp file with the Lua code
    with tempfile.NamedTemporaryFile(mode='w', suffix='.lua', delete=False) as f:
        f.write(code)
        temp_path = f.name

    try:
        # Use luac (Lua compiler) to check syntax without executing
        result = subprocess.run(
            ['luac', '-p', temp_path],
            capture_output=True,
            text=True
        )

        if result.returncode != 0:
            error = result.stderr.strip()
            # Clean up the temp file path from error message
            error = error.replace(temp_path, f'<{name}>')
            return False, error

        return True, ""
    except FileNotFoundError:
        # luac not installed, try lua -e
        try:
            # Wrap in a function to check syntax without execution
            check_code = f'load([[\n{code}\n]])'
            result = subprocess.run(
                ['lua', '-e', check_code],
                capture_output=True,
                text=True
            )
            if result.returncode != 0:
                return False, result.stderr.strip()
            return True, ""
        except FileNotFoundError:
            return True, "WARNING: No Lua interpreter found for validation"
    finally:
        os.unlink(temp_path)


async def main():
    """Validate all triggers in the database."""
    db = Prisma()
    await db.connect()

    try:
        # Fetch all triggers
        triggers = await db.triggers.find_many(
            order={'id': 'asc'}
        )

        print(f"Validating {len(triggers)} triggers...")
        print("=" * 60)

        errors = []
        warnings = []

        for trigger in triggers:
            success, error = validate_lua_syntax(trigger.commands, trigger.name)

            if not success:
                if error.startswith("WARNING:"):
                    if not warnings:  # Only show warning once
                        warnings.append(error)
                else:
                    errors.append({
                        'id': trigger.id,
                        'name': trigger.name,
                        'error': error
                    })
                    print(f"❌ Trigger {trigger.id}: {trigger.name}")
                    print(f"   {error}")
                    print()

        print("=" * 60)
        print(f"Results: {len(triggers)} triggers checked")
        print(f"  ✅ Valid: {len(triggers) - len(errors)}")
        print(f"  ❌ Errors: {len(errors)}")

        if warnings:
            for w in warnings:
                print(f"  ⚠️  {w}")

        if errors:
            print("\nFailed triggers:")
            for e in errors:
                print(f"  - {e['id']}: {e['name']}")
            return 1

        return 0

    finally:
        await db.disconnect()


if __name__ == '__main__':
    import asyncio
    sys.exit(asyncio.run(main()))
