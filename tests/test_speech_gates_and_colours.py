"""R11 trigger fixes: SPEECH_TO keyword gates, legacy colour codes in strings."""

import importlib.util
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
sys.path.insert(0, str(ROOT / "src"))


def _load(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / "scripts" / f"{name}.py")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


FIX = _load("fix_speech_keyword_gates")
WB = _load("fix_speech_word_boundaries")
COL = _load("fix_legacy_colour_codes")
Z = FIX.Z

from fierylib.converters.dg_to_lua import convert_colors, convert_trigger, speech_gate_lines  # noqa: E402
from fierylib.parsers.trigger_parser import DGTrigger, ScriptType  # noqa: E402

LUA = shutil.which("lua5.4") or shutil.which("lua")


def passes(gate_lines, speech):
    """True when the gate lets the script run (does not `return true`)."""
    assert LUA, "lua not installed"
    chunk = f"local speech = {speech!r}\n" + "\n".join(gate_lines) + "\nprint('RAN')\n"
    chunk = "(function()\n" + chunk + "end)()"
    r = subprocess.run([LUA, "-"], input=chunk, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return "RAN" in r.stdout


def dg(flags, prob, arg):
    return DGTrigger(vnum=3007, name="x", script_type=ScriptType.MOB, flags=flags, probability=prob,
                     arg_string=arg, commands="say hi")


def test_speech_to_gets_a_word_gate_from_the_converter():
    lua = convert_trigger(dg(["SPEECH_TO"], 100, "necromancer")).commands
    assert "speech_hit" in lua and '"necromancer"' in lua and "percent_chance" not in lua


def test_speech_num_arg_is_not_a_chance():
    lua = convert_trigger(dg(["SPEECH"], 1, "quest help")).commands
    assert "percent_chance" not in lua and '"quest", "help"' in lua


def test_word_gate_is_whole_word_and_case_insensitive():
    gate = speech_gate_lines('necromancer "grand master"', 100)
    assert passes(gate, "Tell me about the Necromancer!")
    assert passes(gate, "the GRAND MASTER?")
    assert not passes(gate, "banana")
    assert not passes(gate, "necromancers")


def test_phrase_mode_for_num_arg_zero():
    gate = speech_gate_lines("subclass progress", 0)
    assert passes(gate, "Subclass Progress please")
    assert not passes(gate, "subclass")


def test_phrase_mode_needs_word_boundaries():
    gate = speech_gate_lines("follow me", 0)
    assert passes(gate, "Please FOLLOW me.")
    assert passes(gate, "follow me")
    assert not passes(gate, "follow menu")
    assert not passes(gate, "unfollow me")
    assert not passes(gate, "me")  # the old word-by-word OR matched any "me"


def test_word_list_is_whole_word_only():
    gate = speech_gate_lines("heal group", 100)
    assert passes(gate, "can you heal?")
    assert not passes(gate, "healer")
    assert not passes(gate, "regroup")


def test_trailing_punctuation_in_the_arg_is_optional():
    assert passes(speech_gate_lines("help? yes!", 100), "help")
    assert passes(speech_gate_lines("help? yes!", 100), "yes")
    assert passes(speech_gate_lines("I am child of Borgan!", 0), "i am child of borgan")


def test_phrase_with_lua_pattern_magic_characters():
    gate = speech_gate_lines("100% (sure)", 0)
    assert passes(gate, "i am 100% (sure) ok")
    assert not passes(gate, "i am 100% sure")


def test_rewriter_replaces_a_loose_gate_and_keeps_the_rest():
    legacy = {3007: Z.Legacy(3007, "x", 0, "d", 0, "follow me")}
    body = (
        'local s = string.lower(speech)\n'
        'if not (string.find(s, "follow") or string.find(s, "me")) then\n    return true\nend\nsay(s)\n'
    )
    action, out = WB.rewrite(_lua("SPEECH", body), legacy)
    assert action == "fixed"
    assert 'string.find(s, "me")' not in out and "[%s%p]follow me[%s%p]" in out
    assert out.index("local s = string.lower(speech)") < out.index("speech_padded") < out.index("say(s)")


def test_rewriter_leaves_hand_written_and_conditions_in_word_list_mode():
    legacy = {3007: Z.Legacy(3007, "x", 0, "d", 100, "where dough")}
    body = 'if not (string.find(speech, "where") and string.find(speech, "dough")) then\n    return true\nend\n'
    action, _ = WB.rewrite(_lua("SPEECH", body), legacy)
    assert action.startswith("skip:")


def test_star_arg_matches_everything():
    assert speech_gate_lines("*", 100) == [] and speech_gate_lines("", 0) == []


def _lua(flags, body="say hi\n"):
    return (
        f"-- Trigger: x\n-- Zone: 30, ID: 7\n-- Type: MOB, Flags: {flags}\n-- Status: CLEAN\n--\n"
        "-- Original DG Script: #3007\n\n-- Converted from DG Script #3007: x\n"
        f"-- Original: MOB trigger, flags: {flags}, probability: 100%\n{body}"
    )


def test_fixer_inserts_the_gate_after_the_original_line():
    legacy = {3007: Z.Legacy(3007, "x", 0, "n", 100, "necromancer")}
    action, out = FIX.rewrite(_lua("SPEECH_TO"), legacy)
    assert action == "fixed"
    assert out.index("-- Original:") < out.index("speech_hit") < out.index("say hi")


def test_fixer_leaves_scripts_that_already_test_speech():
    legacy = {3007: Z.Legacy(3007, "x", 0, "n", 100, "necromancer")}
    action, out = FIX.rewrite(_lua("SPEECH_TO", 'if speech == "x" then\nend\n'), legacy)
    assert action == "none"


def test_legacy_underline_and_background_codes():
    assert convert_colors("&8shaded&0") == "<u>shaded</>"
    assert convert_colors("&Rwarning&0") == "<bg-red>warning</>"
    assert convert_colors("&1&Bx&0") == "<bg-blue:red>x</>"
    assert convert_colors("R&D and &Q") == "R&D and &Q"


def test_colour_codes_in_set_values():
    assert convert_colors("&3&bCOMBAT&0") == "<b:yellow>COMBAT</>"
    assert convert_colors("&1", carry=True) == "<red>"
    assert convert_colors("&9&bBanish&0.") == "<b:black>Banish</>."
    assert convert_colors("Fire & Ice") == "Fire & Ice"


def test_repair_literal_old_converter_artifacts():
    assert COL.repair_literal("adept at &9<blue>Banish</>.") == "adept at <b:black>Banish</>."
    assert COL.repair_literal("<blue>&9shadowy</> limb") == "<b:black>shadowy</> limb"
    assert COL.repair_literal("<b:green>&uBanish</>") == "<b:u:green>Banish</>"
    assert COL.repair_literal("&3&bGEAR&0, and &3&bLOOT&0") == "<b:yellow>GEAR</>, and <b:yellow>LOOT</>"
    assert COL.repair_literal("&1") == "<red>"
    assert COL.repair_literal("plain <red>text</>") == "plain <red>text</>"


def test_repair_source_skips_comments():
    src = '-- &3&bnote\nactor:send("&3&bhi&0")\n'
    assert COL.repair_source(src) == '-- &3&bnote\nactor:send("<b:yellow>hi</>")\n'


# ---- corpus guards ------------------------------------------------------------------------------

import re  # noqa: E402

import pytest  # noqa: E402

TRIGGERS = ROOT / "data" / "triggers"


def test_corpus_has_no_legacy_colour_codes_in_strings():
    bad = []
    for f in sorted(TRIGGERS.rglob("*.lua")):
        for i, line in enumerate(f.read_text(encoding="utf-8").split("\n"), 1):
            if line.lstrip().startswith("--"):
                continue
            for m in COL.STRING_RE.finditer(line):
                if COL.RESIDUE_RE.search(m.group(1)):
                    bad.append(f"{f.name}:{i}")
    # 060_66 is a documented broken mini-game (bare `p1colO&0` identifiers, not strings).
    assert not bad, bad[:10]


def test_corpus_speech_triggers_keep_their_keyword_test():
    trg = Z.find_dir("lib", "world", "trg")
    if trg is None:
        pytest.skip("legacy lib/world/trg not available")
    legacy = Z.parse_legacy(trg)
    missing = []
    for f in sorted(TRIGGERS.rglob("*.lua")):
        action, _ = FIX.rewrite(f.read_text(encoding="utf-8"), legacy)
        if action == "fixed":
            missing.append(f.name)
    assert not missing, missing[:10]


def test_corpus_speech_gates_use_word_boundaries():
    trg = Z.find_dir("lib", "world", "trg")
    if trg is None:
        pytest.skip("legacy lib/world/trg not available")
    legacy = Z.parse_legacy(trg)
    loose = []
    for f in sorted(TRIGGERS.rglob("*.lua")):
        action, _ = WB.rewrite(f.read_text(encoding="utf-8"), legacy)
        if action.startswith("fixed"):
            loose.append(f.name)
    assert not loose, loose[:10]


def test_megalith_keepers_treat_an_unset_quest_var_as_zero():
    src = (TRIGGERS / "123" / "123_14_megalith_quest_keeper_speech.lua").read_text(encoding="utf-8")
    assert 'get_quest_var("megalith_quest:north") == 0' not in src
    assert src.count(") or 0) == 0") == 4


def test_corpus_speech_needles_are_lowercase():
    """The engine lowercases `speech`, so a needle with a capital letter can never match."""
    pat = re.compile(r'(?:string\.(?:find|match)\(speech(?:_lower)?|speech(?:_lower)? ==)[^\n"]*"([^"\n]*)"')
    bad = []
    for f in sorted(TRIGGERS.rglob("*.lua")):
        for i, line in enumerate(f.read_text(encoding="utf-8").split("\n"), 1):
            if line.lstrip().startswith("--"):
                continue
            for m in pat.finditer(line):
                if re.search(r"[A-Z]", m.group(1)):
                    bad.append(f"{f.name}:{i}")
    assert not bad, bad
