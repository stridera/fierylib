"""Tests for scripts/fix_class_find_checks.py (lowercase class names in string.find)."""

import importlib.util
from pathlib import Path

_SPEC = importlib.util.spec_from_file_location(
    "fix_class_find_checks",
    Path(__file__).resolve().parent.parent / "scripts" / "fix_class_find_checks.py",
)
mod = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(mod)


def fix(src: str) -> str:
    return mod.rewrite(src)[0]


def test_needle_lowercased():
    assert fix('if string.find(actor.class, "Cleric") then') == 'if string.find(actor.class, "cleric") then'


def test_other_receivers_and_wrappers():
    assert fix('string.find(tostring(victim.class), "Priest")') == 'string.find(tostring(victim.class), "priest")'
    assert (
        fix('string.find(string.lower(actor.class or ""), "Sorcerer")')
        == 'string.find(string.lower(actor.class or ""), "sorcerer")'
    )


def test_alias_of_class():
    src = 'local class = actor.class or ""\nif string.find(class, "Monk") then end'
    assert fix(src) == 'local class = actor.class or ""\nif string.find(class, "monk") then end'


def test_non_class_haystack_untouched():
    src = 'if string.find(speech, "Cleric") or string.find(actor.name, "Bob") then'
    assert fix(src) == src


def test_alias_from_comparison_is_not_an_alias():
    src = 'local ok = actor.class == "cleric"\nif string.find(ok, "Yes") then end'
    assert fix(src) == src


def test_magic_char_needle_gets_plain_flag():
    assert fix('string.find(actor.class, "Anti-Paladin")') == 'string.find(actor.class, "anti-paladin", 1, true)'


def test_extra_args_kept_and_no_double_plain():
    assert fix('string.find(actor.class, "Cleric", 1, true)') == 'string.find(actor.class, "cleric", 1, true)'
    once = fix('string.find(actor.class, "Anti-Paladin")')
    assert fix(once) == once


def test_idempotent_on_lowercase():
    src = 'if string.find(actor.class, "cleric") then'
    assert fix(src) == src


def test_prefix_needles_lowercased():
    assert fix('string.find(actor.class, "Anti")') == 'string.find(actor.class, "anti")'


def test_list_form_variable_is_lowered_and_plain():
    assert (
        fix('if string.find(sorcererclasses, actor.class) then')
        == 'if string.find(string.lower(sorcererclasses), actor.class, 1, true) then'
    )
    assert (
        fix('string.find(casters, tostring(victim.class))')
        == 'string.find(string.lower(casters), tostring(victim.class), 1, true)'
    )


def test_list_form_literal_lowered_in_place():
    assert (
        fix('string.find("Cleric Priest Anti-Paladin", actor.class)')
        == 'string.find("cleric priest anti-paladin", actor.class, 1, true)'
    )


def test_comment_lines_skipped():
    src = '-- string.find(actor.class, "Cleric")\n'
    assert fix(src) == src


def test_multiple_calls_one_line_and_nested_parens():
    src = 'if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then'
    assert fix(src) == 'if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then'


def test_non_literal_needle_reported():
    new, edits, unhandled = mod.rewrite("string.find(actor.class, kind)")
    assert new == "string.find(actor.class, kind)" and not edits and unhandled


def test_wrapped_alias():
    src = 'local class = self.class\nlocal x = string.find(tostring(class), "Anti") ~= nil'
    assert fix(src) == 'local class = self.class\nlocal x = string.find(tostring(class), "anti") ~= nil'
