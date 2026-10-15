"""md5-guarded trigger patches and the drift checker accept every stored form of a file.

Some prod Triggers rows hold the whole .lua file (header included, final newline trimmed)
instead of the header-stripped body the importer writes; the guard used to skip those.
"""

import importlib.util
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"


def _load(name):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / f"{name}.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


gen = _load("gen_trigger_patch_sql")
drift = _load("trigger_drift")

OLD = (
    "-- Trigger: Test door\n"
    "-- Zone: 77, ID: 3\n"
    "-- Type: MOB, Flags: GREET\n"
    "-- Status: CLEAN\n"
    "\n"
    'send_to_char("old")\n'
)
NEW = OLD.replace('"old"', '"new"')


def _body(text):
    return gen.parse(text, "x.lua").commands


def test_accepted_forms_cover_body_and_whole_file():
    forms = gen.accepted_forms(OLD, "x.lua")
    assert _body(OLD) in forms
    assert OLD in forms
    assert OLD.rstrip("\n") in forms
    assert _body(OLD).rstrip("\n") in forms
    assert len(forms) == len(set(forms))


def test_guard_sql_lists_every_old_form(monkeypatch, tmp_path):
    path = "data/triggers/77/77_03_door.lua"
    (tmp_path / "data/triggers/77").mkdir(parents=True)
    (tmp_path / path).write_text(NEW, encoding="utf-8")
    monkeypatch.setattr(gen, "ROOT", tmp_path)
    monkeypatch.setattr(gen, "changed_files", lambda base: [path])
    monkeypatch.setattr(gen, "old_text", lambda base, p: OLD)

    sql = gen.build("HEAD~1", "test", guard_md5=True)

    assert "md5(t.commands) = ANY (v.old_md5s)" in sql
    listed = set(re.search(r"ARRAY\[([^\]]*)\]", sql).group(1).replace("'", "").split(", "))
    for form in (_body(OLD), OLD, OLD.rstrip("\n"), _body(OLD).rstrip("\n")):
        assert gen.md5_hex(form) in listed
    # a row holding the new body must not be listed as "old"
    assert gen.md5_hex(_body(NEW)) not in listed


def _repo():
    files = {"a.lua": OLD, "b.lua": OLD.replace("ID: 3", "ID: 4"), "c.lua": OLD.replace("Zone: 77", "Zone: 88")}
    repo = {}
    for name, text in files.items():
        p = gen.parse(text, name)
        repo[(p.zone_id, p.local_id)] = (name, {gen.md5_hex(f) for f in gen.accepted_forms(text, name)})
    return repo


def test_drift_report_from_fake_tsv():
    h = gen.md5_hex
    tsv = [
        # 77:3 stored as whole file, newline trimmed -> clean
        f"77|3|{h(OLD.rstrip(chr(10)))}|2026-10-12 00:00:00|<null>",
        # 77:4 edited in prod -> drifted
        f"77|4|{h('edited')}|2026-10-14 00:00:00|Strider",
        # 5:1 has no file -> prod only
        f"5|1|{h('x')}|2026-10-01 00:00:00|<null>",
        "zone|77",
        "zone|5",
        # zone 88 is not in the DB, so repo-only 88:3 is ignored
    ]
    rows, zones = drift.parse_export(tsv)
    drifted, prod_only, repo_only, clean = drift.compare(rows, zones, _repo())

    assert clean == 1
    assert [d[0] for d in drifted] == [(77, 4)]
    assert [p[0] for p in prod_only] == [(5, 1)]
    assert repo_only == []


def test_repo_only_reported_when_zone_exists_and_tab_separated():
    h = gen.md5_hex
    rows, zones = drift.parse_export([f"77\t3\t{h(OLD)}\t-\t-", "zone\t77", "zone\t88"])
    _, _, repo_only, _ = drift.compare(rows, zones, _repo())
    assert sorted(k for k, _ in repo_only) == [(77, 4), (88, 3)]

    _, no_zone_filter = drift.parse_export([f"77|3|{h(OLD)}|-|-"])
    assert no_zone_filter is None


def _lib_repo():
    def forms(*texts):
        return {drift.md5_norm(t) for t in texts}

    return {
        "a": ("data/script_libraries/a.lua", forms("return 1")),
        "b": ("data/script_libraries/b.lua", forms("return 2")),
        "c": ("data/script_libraries/c.lua", forms("return 3")),
    }


def test_library_drift_report_from_fake_tsv():
    h = drift.md5_norm
    rows = drift.parse_library_export([
        # trailing newline and CRLF are normalised away -> clean
        f"a|{h('return 1' + chr(10))}|2026-10-01 00:00:00|<null>",
        f"b|{h('return 2')}|2026-10-02 00:00:00|<null>",
        # edited in prod -> drifted
        f"c|{h('return 33')}|2026-10-15 17:12:00|builder",
        # no file -> db only
        f"d|{h('x')}|2026-10-14 00:00:00|builder",
    ])
    # a CRLF body hashes like its LF form
    assert h("x\r\ny\r\n") == h("x\ny")
    del rows["b"]  # b only in the repo
    drifted, db_only, repo_only, clean = drift.compare_libraries(rows, _lib_repo())

    assert clean == 1
    assert [d[0] for d in drifted] == ["c"]
    assert [d[0] for d in db_only] == ["d"]
    assert [r[0] for r in repo_only] == ["b"]


def test_library_forms_read_committed_files():
    repo = drift.library_forms()
    assert {"dg", "string_util"} <= set(repo)
    path, hashes = repo["string_util"]
    assert path == "data/script_libraries/string_util.lua"
    assert 1 <= len(hashes) <= 2
