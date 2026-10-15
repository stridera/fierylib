"""Trainer and quest-giver text fixes from playtest r13 (F11)."""

import re
from pathlib import Path

TRIGGERS = Path(__file__).resolve().parents[1] / "data" / "triggers"
CALKEN = TRIGGERS / "030" / "030_165_calken_trainer_speech.lua"
VITYAZ = TRIGGERS / "123" / "123_36_vityaz_exposition.lua"


def _intro_lines():
    text = CALKEN.read_text(encoding="utf-8")
    block = text.split("-- introductions", 1)[1].split("return _return_value", 1)[0]
    return re.findall(r'self\.room:send\((?:tostring\(self\.name\) \.\. )?"(.*)"\)\s*$', block, re.M)


def test_calken_intro_keeps_both_blank_lines():
    lines = _intro_lines()
    assert lines.count("</>") == 2
    # one blank after the greeting and one after "Just ask me about a skill ..."
    ask = lines.index("</>Just ask me about a skill, and I'll give you a quote:")
    assert lines[ask - 1] == "</>" and lines[ask + 1] == "</>"


def test_calken_skill_list_fits_79_columns_and_never_splits_a_skill():
    lines = _intro_lines()
    for line in lines:
        visible = line.replace("</>", "")
        if "says, '" in visible:
            visible = "Calken" + visible
        assert len(visible) <= 79, visible
    text = " ".join(l.replace("</>", "") for l in lines)
    for skill in ("2H bludgeoning weapons", "2H piercing weapons", "2H slashing weapons",
                  "battle howl", "first aid", "ground shaker"):
        assert any(skill in l for l in lines), skill
    # every skill appears whole and the list still ends in a full stop
    assert text.endswith("tantrum.")


def test_vityaz_does_not_say_duty_twice():
    assert "duty duty" not in VITYAZ.read_text(encoding="utf-8")
    assert "in my duty as defender" in VITYAZ.read_text(encoding="utf-8")
