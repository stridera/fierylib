"""scripts/fix_percent_chance_gates.py: the converter's `percent_chance(N)` gate on trigger types where N is no chance."""

import importlib.util
import shutil
import subprocess
import sys
import textwrap
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
_spec = importlib.util.spec_from_file_location("fix_percent_chance_gates", ROOT / "scripts" / "fix_percent_chance_gates.py")
G = importlib.util.module_from_spec(_spec)
sys.modules["fix_percent_chance_gates"] = G
_spec.loader.exec_module(G)
Z = G.Z

LUA = shutil.which("lua5.4") or shutil.which("lua")


def lg(vnum, attach, flags, arg, narg=1):
    return {vnum: Z.Legacy(vnum, "x", attach, flags, narg, arg)}


def trig(attach, flags, n, body, vnum=3027, zone=30, local_id=27):
    return (
        f"-- Trigger: x\n-- Zone: {zone}, ID: {local_id}\n-- Type: {attach}, Flags: {flags}\n-- Status: CLEAN\n--\n"
        f"-- Original DG Script: #{vnum}\n\n-- Converted from DG Script #{vnum}: x\n"
        f"-- Original: {attach} trigger, flags: {flags}, probability: {n}%\n\n"
        f"-- {n}% chance to trigger\nif not percent_chance({n}) then\n    return true\nend\n{body}"
    )


def rw(attach, flags, n, body, legacy=None, **kw):
    return G.rewrite(trig(attach, flags, n, textwrap.dedent(body).lstrip("\n"), **kw), legacy or {})


def run_lua(chunk: str):
    """Run the chunk with a stub environment; returns what it printed."""
    assert LUA, "lua not installed"
    prelude = "function percent_chance() error('rolled') end\nfunction wait() end\n"
    r = subprocess.run([LUA, "-"], input=prelude + chunk, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return r.stdout


# ---- classification -----------------------------------------------------------------------------


def test_chance_types_keep_their_gate():
    for attach, flags in [("MOB", "RANDOM"), ("MOB", "GREET, FIGHT"), ("MOB", "HIT_PERCENT"),
                          ("OBJECT", "GET"), ("OBJECT", "ATTACK"), ("WORLD", "RANDOM, POSTENTRY")]:
        o = rw(attach, flags, 20, "a()\n")
        assert o.action == "keep" and o.src.count("percent_chance(20)") == 1, (attach, flags)


def test_death_and_wear_have_no_roll():
    for attach, flags in [("MOB", "DEATH"), ("OBJECT", "WEAR")]:
        o = rw(attach, flags, 35, "a()\n")
        assert o.action == "nogate"
        assert "percent_chance" not in o.src and "chance to trigger" not in o.src
        assert "num_arg: 35 (no chance roll in legacy)" in o.src
        assert o.src.endswith("a()\n")


def test_mixed_types_with_two_meanings_stay_manual():
    for attach, flags in [("MOB", "DEATH, HIT_PERCENT"), ("MOB", "FIGHT, SPEECH"), ("MOB", "ACT")]:
        o = rw(attach, flags, 20, "a()\n")
        assert o.action == "manual" and "percent_chance(20)" in o.src


# ---- bribe --------------------------------------------------------------------------------------


def test_bribe_num_arg_is_a_minimum_amount():
    o = rw("MOB", "BRIBE", 42, "wait(1)\nself:say('Thanks')\n")
    assert o.action == "bribe"
    assert "percent_chance" not in o.src and "probability" not in o.src
    assert "if (value or 0) < 42 then\n    return true\nend\n" in o.src
    # below the minimum the body is skipped, at or above it runs
    probe = "self = {say = function() print('ran') end}\n"
    body = o.src
    assert run_lua(probe + "value = 41\n" + f"(function()\n{body}\nend)()\n") == ""
    assert run_lua(probe + "value = 42\n" + f"(function()\n{body}\nend)()\n") == "ran\n"


def test_bribe_of_one_copper_needs_no_check():
    o = rw("MOB", "BRIBE", 1, "a()\n")
    assert o.action == "bribe" and "value" not in o.src and "percent_chance" not in o.src


# ---- speech word list ---------------------------------------------------------------------------


def test_speech_gate_becomes_the_legacy_word_list():
    body = """
        -- Speech keywords: quests quest assist help
        local speech_lower = string.lower(speech)
        if not (string.find(string.lower(speech), "quests") or string.find(string.lower(speech), "quest")) then
            return true  -- No matching keywords
        end
        wait(2)
        """
    o = rw("MOB", "SPEECH", 1, body, lg(3027, 0, "d", "quests quest assist help"))
    assert o.action == "speech"
    assert "percent_chance" not in o.src and "Speech keywords" not in o.src and "probability: 1%" not in o.src
    assert 'ipairs({"quests", "quest", "assist", "help"})' in o.src
    assert o.src.endswith("wait(2)\n")


def test_speech_without_any_keyword_block_gets_one_inserted():
    o = rw("MOB", "SPEECH_TO", 1, "if not actor:get_has_completed('q') then\n    self:say('hi')\nend\n",
           lg(3027, 0, "n", "hi hello howdy quest"))
    assert o.action == "speech"
    head, tail = o.src.split("if not speech_hit then", 1)
    assert 'ipairs({"hi", "hello", "howdy", "quest"})' in head
    assert tail.lstrip().startswith("return true") and "get_has_completed" in tail


def test_quoted_phrases_stay_whole_and_everything_is_lowercased():
    assert G.dg_word_list('"Drop off" the junk I') == ["drop off", "the", "junk", "i"]
    assert G.dg_word_list("flame? flames") == ["flame?", "flames"]


def test_generated_word_test_matches_whole_words_and_phrases_only():
    o = rw("MOB", "SPEECH", 1, "print('hit')\n", lg(3027, 0, "d", 'help "drop off" how? i'))
    code = o.src

    def hit(speech):
        out = run_lua(f'speech = "{speech}"\n(function()\n{code}\nend)()\n')
        return out == "hit\n"

    assert hit("Help me!")
    assert not hit("so helpful")
    assert hit("could you drop off the junk?")
    assert not hit("drop it off")
    assert hit("how? now")
    assert not hit("show me")  # "how?" needs the literal question mark and a word edge
    assert hit("I think so")
    assert not hit("this is it")  # the one-letter word "i" is not a letter inside words
    assert not hit("")


def test_speech_without_a_legacy_arg_is_manual():
    o = rw("MOB", "SPEECH", 1, "a()\n", {})
    assert o.action == "manual" and "percent_chance(1)" in o.src


def test_num_arg_zero_is_left_to_the_phrase_fixer():
    o = rw("MOB", "SPEECH_TO", 0, "a()\n", lg(3027, 0, "n", "status", narg=0))
    assert o.action == "manual" and "percent_chance(0)" in o.src


# ---- random + speech -----------------------------------------------------------------------------


def test_random_plus_speech_keeps_the_roll_for_the_random_fire_only():
    body = """
        -- Speech keywords: refresh
        local speech_lower = string.lower(speech)
        if not (string.find(string.lower(speech), "refresh")) then
            return true  -- No matching keywords
        end
        print('body')
        """
    o = rw("MOB", "RANDOM, SPEECH", 1, body, lg(3140, 0, "bd", "refresh"), vnum=3140, zone=30, local_id=140)
    assert o.action == "random-speech"
    src = o.src
    assert src.count("percent_chance(1)") == 1 and 'if speech ~= "" then' in src
    # speech fire: needs the word; random fire (speech == ""): the roll decides
    stub = "function percent_chance(n) return ROLL end\n"
    run = lambda speech, roll: (  # noqa: E731
        subprocess.run([LUA, "-"], input=f'{stub}ROLL = {roll}\nspeech = "{speech}"\n(function()\n{src}\nend)()\n',
                       capture_output=True, text=True).stdout
    )
    assert run("please refresh me", "false") == "body\n"
    assert run("hello", "true") == ""
    assert run("", "true") == "body\n"
    assert run("", "false") == ""


# ---- corpus --------------------------------------------------------------------------------------


def test_the_checked_in_corpus_has_no_misread_gate_left():
    legacy_dir = Z.find_dir("lib", "world", "trg")
    if legacy_dir is None:
        return  # legacy lib not checked out next to the repo
    legacy = Z.parse_legacy(legacy_dir)
    left = []
    for f in sorted((ROOT / "data" / "triggers").rglob("*.lua")):
        o = G.rewrite(f.read_text(encoding="utf-8"), legacy)
        if o.action in {"speech", "random-speech", "bribe", "nogate"}:
            left.append(f.name)
    assert left == []
