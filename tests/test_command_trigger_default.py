"""COMMAND triggers follow legacy script_driver (fierymud-rs trigger dispatch).

Legacy ret_val starts at 1, which blocks the typed command, so converted COMMAND scripts default
to `_return_value = false`; and a COMMAND trigger's numeric argument is not a percent (an
OBJECT's is the OCMD_* location mask).
"""

import re
from pathlib import Path

from fierylib.converters.dg_to_lua import (
    RETURN_VALUE_DEFAULT_ALLOW,
    RETURN_VALUE_DEFAULT_COMMAND,
    command_location_guard,
    convert_trigger,
)
from fierylib.parsers.trigger_parser import DGTrigger, ScriptType

ROOT = Path(__file__).resolve().parent.parent
TRIGGERS = ROOT / "data" / "triggers"
SQL = (ROOT / "data" / "sql" / "2026-10-10-command-trigger-default.sql").read_text(encoding="utf-8")

DG_BODY = "switch %arg%\n  case d\n    return 0\n    halt\ndone\nsay hello\nreturn 0\n"


def dg(script_type, flags, probability, body=DG_BODY, arg="deposit"):
    return DGTrigger(
        vnum=51965,
        name="t",
        script_type=script_type,
        flags=flags,
        probability=probability,
        arg_string=arg,
        commands=body,
    )


def test_command_script_defaults_to_block():
    lua = convert_trigger(dg(ScriptType.MOB, ["COMMAND"], 100)).commands
    assert RETURN_VALUE_DEFAULT_COMMAND in lua
    assert RETURN_VALUE_DEFAULT_ALLOW not in lua
    # An explicit `return 0` still maps to allow.
    assert "_return_value = true\n" in lua


def test_other_triggers_keep_the_allow_default():
    lua = convert_trigger(dg(ScriptType.MOB, ["GREET"], 100)).commands
    assert RETURN_VALUE_DEFAULT_ALLOW in lua
    assert RETURN_VALUE_DEFAULT_COMMAND not in lua


def test_object_command_numeric_arg_is_a_location_mask_not_a_percent():
    lua = convert_trigger(dg(ScriptType.OBJECT, ["COMMAND"], 3)).commands
    assert "percent_chance" not in lua
    assert 'if not (location == "equip" or location == "inventory") then' in lua
    assert command_location_guard(7) == [] and command_location_guard(0) == []
    assert 'location == "room"' in "\n".join(command_location_guard(4))


def test_room_and_mob_command_numeric_arg_is_ignored():
    for script_type in (ScriptType.MOB, ScriptType.WORLD):
        lua = convert_trigger(dg(script_type, ["COMMAND"], 4)).commands
        assert "percent_chance" not in lua and "location" not in lua


def test_mixed_flags_keep_their_percent_gate():
    lua = convert_trigger(dg(ScriptType.OBJECT, ["RANDOM", "COMMAND"], 15)).commands
    assert "percent_chance(15)" in lua


# Hand-written scripts (no converter "N% chance to trigger" header) whose authors read the numeric
# argument as a percent; their gates are replaced by the location guard / removed (see
# 2026-10-10-command-trigger-fixes-2.sql), so no COMMAND-only script may keep one.
HAND_PERCENT_GATES: set[tuple[int, int]] = set()

# COMMAND scripts whose DG source runs `return 0` and then `wait`: legacy let the typed command
# through and the script kept running. A Lua `return true` would end the script, so they call
# `allow_command()` before their first `wait(`.
ALLOW_BEFORE_WAIT = {
    (15, 3), (51, 19), (62, 13), (87, 2), (123, 23), (185, 66), (200, 38), (390, 4), (484, 19),
    (550, 41), (580, 107),
}

# OBJECT COMMAND scripts with no converter header whose numeric argument is a location mask.
HAND_LOCATION_MASKS = {(49, 3): 1, (49, 4): 1, (49, 6): 4, (49, 7): 4, (62, 13): 4, (237, 90): 2, (390, 4): 3}


def command_files():
    for f in sorted(TRIGGERS.rglob("*.lua")):
        text = f.read_text(encoding="utf-8")
        m = re.search(r"^-- Type: (\w+), Flags: (.*)$", text, re.M)
        z = re.search(r"^-- Zone: (\d+), ID: (\d+)$", text, re.M)
        flags = {x.strip() for x in m.group(2).split(",")}
        if "COMMAND" in flags:
            yield (int(z.group(1)), int(z.group(2))), m.group(1), flags, text


def test_data_files_follow_the_converter():
    seen = 0
    for key, typ, flags, text in command_files():
        seen += 1
        assert RETURN_VALUE_DEFAULT_ALLOW not in text, key
        if flags <= {"COMMAND", "GLOBAL"} and key not in HAND_PERCENT_GATES:
            assert not re.search(r"^if not percent_chance\(\d+\) then", text, re.M), key
    assert seen > 380


def test_patch_keys_match_the_data_files():
    default_block = SQL.split("-- 2.1")[0]
    keys = {(int(z), int(i)) for z, i in re.findall(r"\((\d+), (\d+)\)", default_block)}
    by_key = {key: (typ, text) for key, typ, _f, text in command_files()}
    assert len(keys) == 245
    for key in keys:
        assert RETURN_VALUE_DEFAULT_COMMAND in by_key[key][1], key
    # Every COMMAND script that has the new default line is covered by the patch.
    with_new = {k for k, (_t, text) in by_key.items() if RETURN_VALUE_DEFAULT_COMMAND in text}
    assert with_new == keys


def test_patch_is_idempotent_by_construction():
    updates = re.findall(r"UPDATE \"Triggers\"(.*?);\n", SQL, re.S)
    assert len(updates) == 9
    for stmt in updates:
        # Each statement is keyed and only matches text still in the old shape.
        assert "WHERE (zone_id, id) IN (VALUES" in stmt
        assert re.search(r"AND position\(\$old\$.*?\$old\$ in commands\) > 0", stmt, re.S)


def code_of(text):
    return re.sub(r"^\s*--.*$", "", text, flags=re.M)


def test_wait_after_a_legacy_return_zero_calls_allow_command_first():
    by_key = {key: text for key, _t, _f, text in command_files()}
    for key in ALLOW_BEFORE_WAIT:
        code = code_of(by_key[key])
        assert "allow_command()" in code, key
        assert code.index("allow_command()") < code.index("wait("), key


def test_object_command_scripts_keep_their_location_mask():
    checked = 0
    for key, typ, flags, text in command_files():
        if typ != "OBJECT" or not flags <= {"COMMAND", "GLOBAL"}:
            continue
        m = re.search(r"^-- Original: OBJECT trigger, flags: [^\n]*probability: (\d+)%", text, re.M)
        mask = HAND_LOCATION_MASKS.get(key, int(m.group(1)) if m else None)
        if mask is None or mask & 7 in (0, 7) or not code_of(text).strip():
            continue
        checked += 1
        names = [n for bit, n in ((1, "equip"), (2, "inventory"), (4, "room")) if mask & bit]
        cond = " or ".join(f'location == "{n}"' for n in names)
        assert f"if not ({cond}) then" in text, key
    assert checked > 30


FIXES2 = (ROOT / "data" / "sql" / "2026-10-10-command-trigger-fixes-2.sql").read_text(encoding="utf-8")


def test_fixes_2_patch_covers_the_fixed_scripts_and_is_idempotent():
    keys = {(int(z), int(i)) for z, i in re.findall(r"^  \((\d+), (\d+), \$trig\$", FIXES2, re.M)}
    assert len(keys) == 46
    assert ALLOW_BEFORE_WAIT <= keys and set(HAND_LOCATION_MASKS) <= keys
    assert "t.commands IS DISTINCT FROM v.commands" in FIXES2
    assert "ORDER: apply AFTER 2026-10-10-command-trigger-default.sql" in FIXES2
    # Every body in the patch is the file text the importer would write.
    by_key = {key: text for key, _t, _f, text in command_files()}
    for key in keys:
        if key in by_key:
            code = code_of(by_key[key]).strip()
            assert code.splitlines()[0] in FIXES2, key
