"""P-command world caps survive the importer's consolidation, and the prod
patch is idempotent (no DB)."""

from pathlib import Path

from fierylib.importers.reset_importer import ResetImporter

SQL_PATH = Path(__file__).resolve().parents[1] / "data" / "sql" / "2026-10-07-reset-contents-max.sql"


def test_consolidation_keeps_the_legacy_p_max():
    imp = ResetImporter(None)
    out = imp._consolidate_contents(
        [
            {"id": 3298, "max": 20, "name": "rose"},
            {"id": 3298, "max": 20, "name": "rose"},
            {"id": 3299, "max": 1, "name": "thorn"},
        ]
    )
    by_id = {c["id"]: c for c in out}
    assert by_id[3298]["quantity"] == 2
    assert by_id[3298]["max"] == 20
    assert by_id[3299]["max"] == 1


def test_patch_is_idempotent_and_backfills():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert "ADD COLUMN IF NOT EXISTS max_instances" in sql
    assert "(30, 298, 30, 297, 20)" in sql  # black rose in the rose bush
    assert sql.strip().endswith("COMMIT;")
