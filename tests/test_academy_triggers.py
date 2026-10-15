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
