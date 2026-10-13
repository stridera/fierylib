"""Guild armor quest masters (zone 557): playtest round 10 #17."""

import re
from pathlib import Path

ZONE = Path(__file__).resolve().parents[1] / "data" / "triggers" / "557"


def _body(prefix: str) -> str:
    (path,) = ZONE.glob(f"{prefix}_*.lua")
    return path.read_text(encoding="utf-8")


def test_no_raw_dg_get_tokens_reach_the_player():
    for prefix in ("557_02", "557_03", "557_04"):
        body = _body(prefix)
        text = re.sub(r"^--.*$", "", body, flags=re.MULTILINE)
        assert "%get." not in text.replace("`%get.obj_shortdesc/noadesc/pldesc[VNUM]%`", ""), prefix


def test_armor_slot_cascade_matches_the_speech_instead_of_excluding_it():
    body = _body("557_02")
    assert "_name ~= speech" not in body
    assert body.count("slot_matches(") >= 8


def test_progress_is_answered_for_ask_progress_too():
    body = _body("557_04")
    assert '"armor progress"' in body and '"progress"' in body


def test_receive_compares_legacy_vnums_not_local_ids():
    body = _body("557_03")
    assert "object.zone_id" in body and "object.local_id" in body
    assert "object.id ==" not in body
