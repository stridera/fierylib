"""Board privilege rules: the parser must keep them, and the SQL patch must match the parser."""

import json
import os
import re
from pathlib import Path

from fierylib.parsers.board_parser import BoardParser, parse_privilege_rule

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-09-board-privileges.sql").read_text(encoding="utf-8")


def _board(tmp_path, privilege_lines):
    f = tmp_path / "b.brd"
    f.write_text(
        "number: 9\nalias: test\ntitle: Test\n" + "\n".join(privilege_lines) + "\n~~\n",
        encoding="utf-8",
    )
    board = BoardParser().parse_file(f)
    assert board is not None
    return board


def test_level_rule_is_kept(tmp_path):
    board = _board(tmp_path, ["privilege: 0 level 1 105", "privilege: 1 level 105 105"])
    assert board.privileges == [
        {"privilege": "Read", "level": 1, "maxLevel": 105},
        {"privilege": "WriteNew", "level": 105, "maxLevel": 105},
    ]


def test_wof_boards_are_public_to_everyone():
    assert parse_privilege_rule(0, "level 0 105") == {
        "privilege": "Read",
        "level": 0,
        "maxLevel": 105,
    }


def test_blank_rule_defaults_and_moderation_slots_need_immortal():
    assert parse_privilege_rule(0, "")["level"] == 0
    assert parse_privilege_rule(1, " ")["level"] == 0
    for slot in (4, 5, 6, 7):
        assert parse_privilege_rule(slot, "")["level"] == 100


def test_unknown_rules_are_kept_verbatim():
    assert parse_privilege_rule(4, "1 janara kourrya") == {
        "privilege": "RemoveAny",
        "rule": "1 janara kourrya",
    }
    assert parse_privilege_rule(0, "2 4 1") == {"privilege": "Read", "rule": "2 4 1"}


def test_bad_slots_are_ignored(tmp_path):
    assert parse_privilege_rule(8, "level 0 105") is None
    assert _board(tmp_path, ["privilege: x level 0 105"]).privileges == []


def test_sql_patch_matches_the_parser_for_every_legacy_board():
    boards_dir = Path(
        os.environ.get(
            "LEGACY_BOARDS_DIR",
            Path(__file__).resolve().parents[2] / "lib" / "etc" / "boards",
        )
    )
    if not boards_dir.is_dir():
        return  # legacy lib/ is not checked out here
    from fierylib.parsers.board_parser import parse_all_boards

    in_sql = dict(re.findall(r"\('(\w+)', '(\[.*?\])'::jsonb\)", SQL))
    boards = parse_all_boards(boards_dir)
    assert {b.alias for b in boards} == set(in_sql)
    for b in boards:
        assert json.loads(in_sql[b.alias]) == b.privileges


def test_sql_patch_is_idempotent_by_construction():
    assert "IS DISTINCT FROM" in SQL
