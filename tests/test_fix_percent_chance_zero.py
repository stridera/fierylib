"""scripts/fix_percent_chance_zero.py: the converter's dead `percent_chance(0)` guard."""

import importlib.util
import shutil
import subprocess
import sys
import textwrap
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
_spec = importlib.util.spec_from_file_location("fix_percent_chance_zero", ROOT / "scripts" / "fix_percent_chance_zero.py")
P = importlib.util.module_from_spec(_spec)
sys.modules["fix_percent_chance_zero"] = P
_spec.loader.exec_module(P)

LUA = shutil.which("lua5.4") or shutil.which("lua")
LUAC = shutil.which("luac5.4") or shutil.which("luac")
RANGES = [(55500, 55599, 555), (3000, 3499, 30), (200, 399, 2)]
GUARD = "-- 0% chance to trigger\nif not percent_chance(0) then\n    return true\nend\n"


def lg(vnum, attach, flags, arg, narg=0, name="x"):
    return {vnum: P.Legacy(vnum, name, attach, flags, narg, arg)}


def trig(vnum, body, header="-- Trigger: x\n-- Zone: 30, ID: 1\n"):
    return f"{header}--\n-- Original DG Script: #{vnum}\n\n{GUARD}{body}"


def rw(vnum, legacy, body):
    return P.rewrite(trig(vnum, textwrap.dedent(body).lstrip("\n")), legacy, RANGES)


# ---- speech -------------------------------------------------------------------------------------


def test_speech_keyword_or_chain_becomes_one_phrase_test():
    o = rw(
        3090,
        lg(3090, 0, "d", "I need a new notice"),
        """
        -- Speech keywords: I need a new notice
        local speech_lower = string.lower(speech)
        if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need")) then
            return true  -- No matching keywords
        end
        wait(2)
        """,
    )
    assert o.kind == "fixed-speech"
    assert "percent_chance" not in o.src and "Speech keywords" not in o.src
    assert 'if not string.find(string.lower(speech), "i need a new notice", 1, true) then' in o.src
    assert "local speech_lower" not in o.src  # nothing reads it later
    assert o.src.rstrip().endswith("wait(2)")


def test_speech_lower_local_is_kept_when_the_body_reads_it():
    o = rw(
        3090,
        lg(3090, 0, "n", "spell progress"),
        """
        local speech_lower = string.lower(speech)
        if not (string.find(speech_lower, "spell")
                and string.find(speech_lower, "progress")) then
            return true
        end
        if string.find(speech_lower, "x") then a() end
        """,
    )
    assert o.kind == "fixed-speech"
    assert "local speech_lower = string.lower(speech)\nif not string.find(speech_lower, \"spell progress\"" in o.src
    assert o.src.count("local speech_lower") == 1


def test_speech_phrase_is_escaped_and_stale_todo_comments_go():
    o = rw(
        2229,
        lg(2229, 2, "d", 'Say "hi" \\ now.'),
        """
        -- TODO(parity): original DG keyword was the exact phrase "x";
        -- converter split it into OR of common words
        -- Should require all keywords to match (admin-only reset speech).
        local speech_lower = string.lower(speech)
        if not (string.find(speech_lower, "say")) then
            return true  -- No matching keywords
        end
        a()
        """,
    )
    assert o.kind == "fixed-speech"
    assert '"say \\"hi\\" \\\\ now."' in o.src
    assert "TODO(parity)" not in o.src


def test_speech_without_a_keyword_block_is_manual():
    o = rw(3090, lg(3090, 0, "d", "hello"), "wait(2)\nif speech == 'x' then a() end\n")
    assert o.kind == "manual" and GUARD.strip().splitlines()[1] in o.src


# ---- receive ------------------------------------------------------------------------------------


def test_receive_excludes_the_arg_list_items():
    o = rw(3035, lg(3035, 0, "j", "55577 3123 340"), "wait(1)\nself:say('Thanks!')\n")
    assert o.kind == "fixed-receive"
    assert "if not percent_chance(0)" not in o.src
    assert (
        "if (object.zone_id == 555 and object.id == 77)\n"
        "    or (object.zone_id == 30 and object.id == 123)\n"
        "    or (object.zone_id == 2 and object.id == 140) then\n"
        "    return true\nend\n"
    ) in o.src
    assert o.src.endswith("wait(1)\nself:say('Thanks!')\n")


def test_receive_with_a_vnum_outside_every_zone_is_manual():
    o = rw(3035, lg(3035, 0, "j", "99999"), "a()\n")
    assert o.kind == "manual" and "percent_chance(0)" in o.src


# ---- other types --------------------------------------------------------------------------------


def test_world_global_and_death_just_lose_the_guard():
    g = rw(12317, lg(12317, 2, "a", ""), "wait(2)\n")
    assert g.kind == "fixed-global" and "percent_chance(0) then" not in g.src and "run_room_trigger" in g.src
    d = rw(62549, lg(62549, 0, "f", ""), "return true\n")
    assert d.kind == "fixed-death" and "percent_chance(0) then" not in d.src


@pytest.mark.parametrize(
    "attach,flags,arg,narg,needle",
    [
        (0, "ab", "", 0, "RANDOM"),  # legacy random with 0% never fires
        (0, "e", "pets you lovingly.", 0, "ACT"),
        (2, "cfg", "", 0, "not a trigger type"),
        (0, "d", "hello", 25, "num_arg is not 0"),
    ],
)
def test_other_types_are_left_and_listed(attach, flags, arg, narg, needle):
    o = rw(3090, lg(3090, attach, flags, arg, narg), "a()\n")
    assert o.kind == "manual" and needle in o.reason and "percent_chance(0) then" in o.src


def test_documented_broken_body_is_kept():
    body = "-- Leaving the body intact for later rewrite.\nlocal c = actor.class == Warrior\n"
    o = rw(55606, lg(55606, 0, "n", "status"), body)
    assert o.kind == "manual" and "documented as broken" in o.reason


def test_unknown_legacy_trigger_is_manual_and_a_guardless_file_is_untouched():
    o = rw(3090, {}, "a()\n")
    assert o.kind == "manual"
    clean = "-- Original DG Script: #1\na()\n"
    assert P.rewrite(clean, {}, RANGES).kind == "none"


def test_legacy_found_by_zone_id_and_name_when_the_header_has_no_vnum():
    src = "-- Trigger: charm_person_serenade_speech\n-- Zone: 30, ID: 6\n--\n" + GUARD + (
        "if not (string.find(string.lower(speech), \"let\")) then\n    return true\nend\na()\n"
    )
    leg = lg(3006, 0, "d", "let me serenade you", name="charm_person_serenade_speech")
    assert P.rewrite(src, leg, RANGES).kind == "fixed-speech"
    assert P.rewrite(src, lg(3006, 0, "d", "x", name="other"), RANGES).kind == "manual"


def test_rewrite_is_idempotent():
    o = rw(3090, lg(3090, 0, "d", "hello"), "if not (string.find(speech, 'h')) then\n    return true\nend\na()\n")
    assert P.rewrite(o.src, lg(3090, 0, "d", "hello"), RANGES).kind == "none"


def test_legacy_trg_parser():
    import tempfile

    with tempfile.TemporaryDirectory() as d:
        (Path(d) / "30.trg").write_text(
            "#3090\nIsilynor new contract~\n0 d 0\nI need a new notice~\nwait 2\n~\n"
            "#3035\nMagistrate refuse~\n0 j 0\n55211 340~\nsay Thanks!\n~\n$~\n"
        )
        got = P.parse_legacy(Path(d))
    assert got[3090].arg == "I need a new notice" and got[3090].flags == "d" and got[3090].narg == 0
    assert got[3035].attach == 0 and got[3035].arg == "55211 340"


# ---- the corpus ---------------------------------------------------------------------------------


KEPT = {
    "030_115_bite_or_wag_animals.lua",  # ACT: not dispatched by the runtime
    "123_24_vityaz_random_spark.lua",  # RANDOM 0%: never fires in legacy
    "360_11_test2.lua",  # test script
}


def test_only_the_documented_manual_cases_still_carry_the_guard():
    left = sorted(
        p.name
        for p in (ROOT / "data" / "triggers").rglob("*.lua")
        if "if not percent_chance(0) then" in p.read_text(encoding="utf-8")
    )
    unexpected = [n for n in left if n not in KEPT and not n.startswith("556_")]
    assert unexpected == []
    assert KEPT <= set(left)
    # the 556 phase-armor status scripts are documented as broken in their own header
    for p in (ROOT / "data" / "triggers" / "556").glob("*.lua"):
        t = p.read_text(encoding="utf-8")
        if "if not percent_chance(0) then" in t:
            assert P.BROKEN_BODY_MARKER in t, p.name


def test_corpus_is_fully_rewritten():
    trg, zon = P.find_dir("lib", "world", "trg"), P.find_dir("lib", "world", "zon")
    if trg is None or zon is None:
        pytest.skip("legacy lib/world not found")
    from fierylib.converters.dg_to_lua import build_zone_ranges

    legacy, ranges = P.parse_legacy(trg), build_zone_ranges(zon)
    dirty = []
    for f in sorted((ROOT / "data" / "triggers").rglob("*.lua")):
        src = f.read_text(encoding="utf-8")
        o = P.rewrite(src, legacy, ranges, str(f))
        if o.kind.startswith("fixed"):
            dirty.append(f.name)
    assert not dirty, f"rerun scripts/fix_percent_chance_zero.py: {dirty[:5]}"


@pytest.mark.skipif(LUAC is None, reason="no luac")
def test_every_fixed_script_still_compiles():
    out = subprocess.run(
        [LUAC, "-p", *map(str, sorted((ROOT / "data" / "triggers").rglob("*.lua")))],
        capture_output=True, text=True,
    )
    assert out.returncode == 0, out.stderr[:500]
