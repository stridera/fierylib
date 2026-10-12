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
    assert '"hello class", 1, true' in _body("519_02")
    assert '"hello teacher", 1, true' in _body("519_03")
    assert '"hit points", 1, true' in _body("519_86")


def test_blocked_exit_says_what_to_do():
    body = _body("519_77")
    assert "not quite ready to move on yet" in body
    assert "SKIP" in body and "EXIT" in body
