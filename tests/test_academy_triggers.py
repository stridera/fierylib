"""Ethilien Training Academy (zone 519) tutorial triggers: playtest round 5, N4."""

from pathlib import Path

ZONE = Path(__file__).resolve().parents[1] / "data" / "triggers" / "519"


def _body(prefix: str) -> str:
    (path,) = ZONE.glob(f"{prefix}_*.lua")
    return path.read_text(encoding="utf-8")


def test_no_academy_trigger_is_disabled_by_a_zero_percent_chance():
    # The DG speech triggers carry argument 0, which means "match the phrase",
    # not "0% chance". The converter turned it into `percent_chance(0)`, which
    # never passes, so the lesson never advanced past "say hello class".
    offenders = [p.name for p in ZONE.glob("*.lua") if "percent_chance(0)" in p.read_text(encoding="utf-8")]
    assert offenders == []


def test_phrase_triggers_match_their_dg_phrase():
    assert "[%s%p]hello class[%s%p]" in _body("519_02")
    assert "[%s%p]hello teacher[%s%p]" in _body("519_03")
    assert "[%s%p]hit points[%s%p]" in _body("519_86")


def test_blocked_exit_says_what_to_do():
    body = _body("519_77")
    assert "not quite ready to move on yet" in body
    assert "SKIP" in body and "EXIT" in body


def test_gear_lesson_put_listens_for_a_drop_with_a_container_target():
    # `put stick bag` fires the stick's DROP trigger with the bag as `target`
    # (legacy perform_put); a plain `drop` has no target, so the branch is nil-safe.
    body = _body("519_12")
    assert "target and target.id == 18" in body


def test_explore_lesson_treats_a_bare_look_as_no_argument():
    # The engine binds `arg` to "" for a bare `look`, which is truthy in Lua.
    body = _body("519_17")
    assert '(arg == nil or arg == "")' in body
    assert "and not arg" not in body


def test_sorcerer_spell_lesson_filters_the_spells_command():
    body = _body("519_48")
    assert 'cmd == "spells"' in body
    assert 'cmd == "spell")' not in body


def test_no_command_trigger_tests_an_argument_for_plain_truthiness():
    # `not arg` / `if arg then` are wrong for COMMAND args: an empty argument is "".
    import re

    root = ZONE.parent
    offenders = []
    for path in root.glob("*/*.lua"):
        text = path.read_text(encoding="utf-8")
        if "Flags: COMMAND" not in text and "Flags: LOOK" not in text:
            continue
        for line in text.splitlines():
            if re.search(r"\bnot arg\b(?! *or)", line) or re.fullmatch(r"\s*if arg then", line):
                offenders.append(f"{path.name}: {line.strip()}")
    assert offenders == []


def _picked_word(prefix: str, speech: str):
    """Run a word-list trigger's gate in Lua; return the word it branches on (None = gate rejected)."""
    import shutil
    import subprocess

    lua = shutil.which("lua5.4") or shutil.which("lua")
    assert lua, "lua not installed"
    body = _body(prefix)
    gate = body[body.index("local speech_padded") : body.index("wait(0.2)")]
    chunk = f"(function()\nlocal speech = {speech!r}\n{gate}\nprint('WORD=' .. tostring(speech_word))\nend)()"
    r = subprocess.run([lua, "-"], input=chunk, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return r.stdout.strip().removeprefix("WORD=") if "WORD=" in r.stdout else None


def test_word_list_triggers_branch_on_the_matched_word_not_the_raw_speech():
    # playtest r12: "say BASIC!" and "say Basic please" ran the gate but no branch,
    # because the branches compared the whole (lowercased) speech to the word.
    for prefix in ("519_00", "519_04", "519_05", "519_88"):
        assert 'speech == "' not in _body(prefix).replace("speech_word == ", "")
    assert _picked_word("519_00", "BASIC!") == "basic"
    assert _picked_word("519_00", "Basic please") == "basic"
    assert _picked_word("519_00", "I want combat, thanks") == "combat"
    assert _picked_word("519_00", "None.") == "none"
    assert _picked_word("519_00", "basically") is None  # the gate rejects, no word picked
    assert _picked_word("519_04", "Yes, please") == "yes"
    assert _picked_word("519_05", "Gossip!") == "gossip"
    assert _picked_word("519_88", "SKIP it") == "skip"


# SPEECH/RECEIVE triggers that may still compare the raw speech for equality (zone:id -> why). Empty on
# purpose: DG `==` on %speech% was an exact compare, but players type "say dodge please", so every
# word-list trigger branches on `speech_word` (or a `topic` found in the speech), and DG `/=`
# (contains) uses string.find.
EXACT_SPEECH_ALLOWED: dict[str, str] = {}


def test_no_speech_trigger_compares_the_raw_speech_for_equality():
    import re

    root = ZONE.parent
    offenders = []
    for path in sorted(root.glob("*/*.lua")):
        text = path.read_text(encoding="utf-8")
        flags = re.search(r"^-- Type: \w+, Flags: (.*)$", text, re.M)
        if not flags or not re.search(r"SPEECH|RECEIVE", flags.group(1)):
            continue
        if path.name in EXACT_SPEECH_ALLOWED:
            continue
        for n, line in enumerate(text.splitlines(), 1):
            if not line.lstrip().startswith("--") and re.search(r"\bspeech\s*==|==\s*speech\b", line):
                offenders.append(f"{path.name}:{n}: {line.strip()}")
    assert offenders == []


def test_trainers_find_the_topic_inside_a_longer_sentence():
    import shutil
    import subprocess

    lua = shutil.which("lua5.4") or shutil.which("lua")
    assert lua, "lua not installed"
    for prefix, speech, want in (
        ("030_165", "Dodge please!", "dodge"),
        ("030_165", "tell me about first aid", "first aid"),
        ("030_160", "sneak attack?", "sneak attack"),
        ("030_160", "how much for sneak", "sneak"),
        ("030_170", "quick chant", "quick chant"),
        ("030_165", "yes", "yes"),
    ):
        (path,) = (ZONE.parent / "030").glob(f"{prefix}_*.lua")
        body = path.read_text(encoding="utf-8")
        scan = body[body.index("local topic") : body.index("-- introductions")]
        chunk = f"local speech_padded = ' ' .. string.lower({speech!r}) .. ' '\n{scan}\nprint(topic)"
        r = subprocess.run([lua, "-"], input=chunk, capture_output=True, text=True)
        assert r.returncode == 0, r.stderr
        assert r.stdout.strip() == want, (prefix, speech)
