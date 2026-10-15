"""DG `%get.<func>[VNUM]%` prototype lookups: converter output and the helper block it carries.

VNUM is the legacy id zone * 100 + id (zone 0 is zone 1000). fierymud-rs has no vnums, so the
converted body defines small local helpers (PROTO_HELPERS) that split it into the composite key
and call objects.template / mobiles.template / get_obj_noadesc / get_room.
"""

import shutil
import subprocess

import pytest

from fierylib.converters.dg_to_lua import convert_script_body, proto_helper_block

LUA = shutil.which("lua5.4") or shutil.which("lua")
needs_lua = pytest.mark.skipif(LUA is None, reason="lua not installed")

SRC = (
    "set necklace 3045\n"
    "eval room %get.room[%place%]%\n"
    "msend %actor% at %get.room[%place%].name% find %get.obj_shortdesc[%necklace%]% "
    "or %get.mob_shortdesc[%necklace%]%\n"
    "msend %actor% %get.obj_noadesc[%necklace%]% and %get.obj_pldesc[3045]%\n"
)


def test_converter_emits_helper_calls_not_nonexistent_functions():
    out = convert_script_body(SRC)
    assert "vnum_to_zone" not in out and "vnum_to_local" not in out
    assert 'proto_short(necklace)' in out and "mob_short(necklace)" in out
    assert "proto_noa(necklace)" in out and "proto_plural(3045)" in out
    assert "room_by_vnum(globals.place)" in out and "room_name(globals.place)" in out
    assert "%get" not in out and "tostring(proto_short" not in out
    for name in ("proto_key", "proto_short", "mob_short", "proto_noa", "proto_plural",
                 "room_by_vnum", "room_name"):
        assert f"local function {name}(" in out


def test_helper_block_only_carries_what_is_used_and_not_redefined():
    assert proto_helper_block("print(1)") == ""
    block = proto_helper_block('x = proto_short(3045)')
    assert "local function proto_key" in block and "local function proto_short" in block
    assert "mob_short" not in block
    own = "local function proto_short(v) return 'x' end\nprint(proto_short(1))"
    assert "local function proto_short" not in proto_helper_block(own)


@needs_lua
def test_helpers_split_vnums_and_map_zone_zero(tmp_path):
    block = proto_helper_block("proto_short(1) mob_short(1) proto_noa(1) proto_plural(1) room_name(1)")
    script = tmp_path / "t.lua"
    script.write_text(
        'local names = {["30:45"] = "a gleaming trident", ["1000:7"] = "Anvil", ["23:3"] = "a pair of boots"}\n'
        'objects = {template = function(z, i) return {name = names[z .. ":" .. i] or ""} end}\n'
        'mobiles = {template = function(z, i) return {name = "mob " .. z .. ":" .. i} end}\n'
        'get_obj_noadesc = function(z, i)\n'
        '  local n = names[z .. ":" .. i]\n'
        '  return (n:gsub("^a pair of ", ""):gsub("^an? ", ""))\n'
        'end\n'
        'get_room = function(z, i) if z == 30 and i == 1 then return {name = "the chapel"} end end\n'
        + block
        + '\nprint(proto_short(3045), proto_short(7), mob_short(4012), proto_short("x"), proto_short(9999))\n'
        'print(proto_noa(3045), proto_plural(2303), room_name(3001), room_name(nil), room_name(9999))\n'
    )
    out = subprocess.run([LUA, str(script)], capture_output=True, text=True, check=True).stdout.splitlines()
    assert out[0].split("\t") == [
        "a gleaming trident", "Anvil", "mob 40:12", "[no description for object x]",
        "[no description for object 9999]",
    ]
    assert out[1].split("\t") == ["gleaming trident", "boots", "the chapel", "", ""]


def test_literal_vnums_are_split_at_conversion_time():
    from fierylib.converters.dg_to_lua import convert_text_with_vars

    assert convert_text_with_vars("%get.obj_shortdesc[3045]%") == "tostring(objects.template(30, 45).name)"
    assert convert_text_with_vars("%get.mob_shortdesc[3045]%") == "tostring(mobiles.template(30, 45).name)"
    assert convert_text_with_vars("%get.obj_noadesc[3045]%") == "get_obj_noadesc(30, 45)"
    # the old zone 0 is zone 1000
    assert convert_text_with_vars("%get.obj_shortdesc[7]%") == "tostring(objects.template(1000, 7).name)"
