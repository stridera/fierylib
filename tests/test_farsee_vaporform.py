"""EFF_FARSEE is its own flag; Vaporform is mist composition (fierymud-rs #35)."""

import json
import re
from pathlib import Path

from fierylib.converters.flag_normalizer import (
    MOB_EFFECT_FLAG_TO_STATUS_FLAG,
    OBJECT_STATUS_FLAG_TABLE,
    mob_default_status_flags,
    process_mob_flags,
)

DATA = Path(__file__).resolve().parent.parent / "data"
SQL_DIR = DATA / "sql"
FARSEE_SQL = (SQL_DIR / "2026-10-10-mob-farsee.sql").read_text(encoding="utf-8")
VAPOR_SQL = (SQL_DIR / "2026-10-10-vaporform.sql").read_text(encoding="utf-8")
MOB_ROWS = (SQL_DIR / "2026-10-07-mob-default-effects.sql").read_text(encoding="utf-8")
BY_NAME = {a["plainName"]: a for a in json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))}
STATUS_ENUM = next(e for e in json.loads((DATA / "effects.json").read_text(encoding="utf-8")) if e["name"] == "status")[
    "paramSchema"
]["properties"]["flag"]["enum"]


def test_farsee_maps_to_farsee_not_detect_hidden():
    assert MOB_EFFECT_FLAG_TO_STATUS_FLAG["FARSEE"] == "farsee"
    assert OBJECT_STATUS_FLAG_TABLE["FARSEE"] == "farsee"
    flags, skipped = mob_default_status_flags(["FARSEE", "DETECT_INVIS"])
    assert flags == ["detect_invisible", "farsee"]
    assert skipped == []
    assert process_mob_flags(["SENTINEL"], ["FARSEE"]).default_status_flags == ["farsee"]
    assert "detect_hidden" not in MOB_EFFECT_FLAG_TO_STATUS_FLAG.values()


def test_generated_mob_rows_no_longer_carry_detect_hidden():
    assert "detect_hidden" not in MOB_ROWS
    assert len(re.findall(r'"farsee"', MOB_ROWS.split("BEGIN;")[1])) == 20


def test_patch_is_keyed_by_mob_and_covers_every_farsee_mob():
    mob_stmt = FARSEE_SQL.split('UPDATE "ObjectEffects"')[0]
    keys = re.findall(r"^\s+\((\d+), (\d+)\)", mob_stmt, re.M)
    assert len(keys) == len(set(keys)) == 20
    # Every mob the generator now gives "farsee" is in the patch (zone_id, id).
    generated = re.findall(r"^\s+\((\d+), (\d+), '\{.*\"farsee\".*\}'\)", MOB_ROWS, re.M)
    assert sorted(keys) == sorted(generated)
    assert "(d.mob_zone_id, d.mob_id) IN (VALUES" in mob_stmt


def test_patch_is_idempotent_and_keeps_the_other_flags():
    # Only rows still carrying detect_hidden are touched, so a second run matches nothing.
    assert FARSEE_SQL.count("AND d.modifier_data->'flags' ? 'detect_hidden';") == 2
    assert "THEN 'farsee' ELSE t.f END" in FARSEE_SQL
    assert re.search(r"BEGIN;.*COMMIT;", FARSEE_SQL, re.S)


def test_vaporform_is_its_own_flag():
    (row,) = [e for e in BY_NAME["VAPORFORM"]["effects"] if e["effect"] == "status"]
    assert row["params"]["flag"] == "vaporform"
    assert "invisib" not in BY_NAME["VAPORFORM"]["description"].lower()
    for flag in ("farsee", "waterform", "vaporform"):
        assert flag in STATUS_ENUM


def test_vaporform_sql_is_keyed_by_plain_name_and_idempotent():
    assert "a.plain_name = 'VAPORFORM'" in VAPOR_SQL
    assert "e.name = 'status'" in VAPOR_SQL
    assert "ae.override_params->>'flag' = 'invisible'" in VAPOR_SQL
    assert '\'"vaporform"\'::jsonb' in VAPOR_SQL
    assert not re.search(r"\bid\s*=\s*\d", VAPOR_SQL)
