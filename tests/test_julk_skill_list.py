"""Julk's skill list (30:160): blank echo lines kept, no line wider than 79 columns."""

import re
from pathlib import Path

LUA = Path(__file__).resolve().parents[1] / "data" / "triggers" / "030" / "030_160_skill_trainer_speach.lua"


def _intro_lines():
    text = LUA.read_text(encoding="utf-8")
    block = text.split("-- introductions", 1)[1].split("return _return_value", 1)[0]
    return re.findall(r'self\.room:send\((?:tostring\(self\.name\) \.\. )?"(.*)"\)\s*$', block, re.M)


def test_intro_keeps_blank_lines_and_fits_79_columns():
    lines = _intro_lines()
    assert lines.count("</>") == 2
    for line in lines:
        visible = line.replace("</>", "")
        if "says, '" in visible:
            visible = "Julk" + visible
        assert len(visible) <= 79, visible


def test_skill_list_does_not_split_a_skill_across_lines():
    lines = [l.replace("</>", "") for l in _intro_lines()]
    for skill in ("pick lock", "sneak attack", "double attack", "group retreat"):
        assert any(skill in l for l in lines), skill
