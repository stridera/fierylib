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
