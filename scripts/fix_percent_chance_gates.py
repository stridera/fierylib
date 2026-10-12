#!/usr/bin/env python3
"""Fix the converter's leading `percent_chance(N)` gate where N was never a probability.

The DG-to-Lua converter turned a trigger's numeric argument into

    if not percent_chance(N) then
        return true
    end

for every trigger type. dg_triggers.cpp (legacy) only uses it as a chance for some types. Per type:

  chance (gate kept)    MOB RANDOM GREET GREET_ALL ENTRY FIGHT LOAD CAST LEAVE DOOR LOOK; OBJECT RANDOM
                        TIMER GET DROP GIVE REMOVE LOOK USE LOAD CAST LEAVE ATTACK DEFEND; WORLD RANDOM
                        RESET PREENTRY POSTENTRY DROP CAST LEAVE DOOR. HIT_PERCENT also keeps it: the
                        runtime reads it back as the HP% threshold (triggers.rs split_leading_gate).
  word list (removed)   MOB SPEECH / SPEECH_TO, num_arg != 0: the arg is a list of words / "quoted
                        phrases"; the speech must contain one (word_check -> is_substring, case
                        insensitive, whole words). The gate is replaced by that test, built from the
                        legacy arg. num_arg 0 means "contains the whole phrase" and is handled by
                        fix_percent_chance_zero.py.
  minimum value         MOB BRIBE: fires when the coin value in copper is >= num_arg. Gate becomes
                        `if value < N then return true end` (nothing for N <= 1).
  no roll (removed)     MOB DEATH; OBJECT WEAR (and a COMMAND whose num_arg is the where-bitmask).

Anything else (ACT, mixed types whose gate would mean two things, bodies marked broken) is listed and
left alone.

Usage:
    python scripts/fix_percent_chance_gates.py [--check] [--trg DIR] [--report FILE] [PATH ...]
"""

from __future__ import annotations

import argparse
import collections
import re
import sys
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))
sys.path.insert(0, str(ROOT / "scripts"))

import fix_percent_chance_zero as Z  # noqa: E402

GATE_RE = re.compile(
    r"^if not percent_chance\((?P<n>\d+)\) then\n[ \t]+return true[^\n]*\n^end\n",
    re.M,
)
HEADER_TYPE_RE = re.compile(r"^-- Type: (?P<attach>\w+), Flags: (?P<flags>.*)$", re.M)
PROB_COMMENT_RE = re.compile(r"chance to trigger|converter mistranslated|Disabled by legacy|probability:")

CHANCE = {
    "MOB": {"RANDOM", "GREET", "GREET_ALL", "ENTRY", "FIGHT", "LOAD", "CAST", "LEAVE", "DOOR", "LOOK", "HIT_PERCENT"},
    "OBJECT": {"RANDOM", "TIMER", "GET", "DROP", "GIVE", "REMOVE", "LOOK", "USE", "LOAD", "CAST", "LEAVE",
               "ATTACK", "DEFEND"},
    "WORLD": {"RANDOM", "RESET", "PREENTRY", "POSTENTRY", "DROP", "CAST", "LEAVE", "DOOR"},
}
SPEECH_FLAGS = {"SPEECH", "SPEECH_TO"}
# Scripts whose flags mix a chance type with something else but are still safe to fix by hand-picked rule.
OVERRIDES = {
    # Object COMMAND/WEAR/RANDOM: num_arg is the where-bitmask and WEAR has no roll; the body is
    # filtered on `cmd == "lylaith"`, so with no gate the RANDOM fires just return.
    (12, 65): "nogate",
    # RANDOM + SPEECH (both documented in the script): keyword for speech, chance for the random fire.
    (30, 140): "random-speech",
    (30, 40): "random-speech",
}


def _lua_str(s: str) -> str:
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def dg_word_list(arg: str) -> list[str]:
    """Legacy word_check list: space separated words, or "double quoted phrases" (delimited_arg)."""
    out: list[str] = []
    i, n = 0, len(arg)
    while i < n:
        while i < n and arg[i].isspace():
            i += 1
        if i >= n:
            break
        if arg[i] == '"':
            j = arg.find('"', i + 1)
            j = n if j < 0 else j
            word = arg[i + 1 : j]
            i = j + 1
        else:
            j = i
            while j < n and not arg[j].isspace():
                j += 1
            word = arg[i:j]
            i = j
        if word:
            out.append(word.lower())
    return out


def speech_block(words: list[str], note: str) -> str:
    items = ", ".join(_lua_str(w) for w in words)
    return (
        f"-- DG word list ({note}): the speech must contain one of these as a whole word or phrase.\n"
        "local speech_padded = \" \" .. string.lower(speech) .. \" \"\n"
        "local speech_hit = false\n"
        f"for _, w in ipairs({{{items}}}) do\n"
        "    if string.find(speech_padded, \"[%s%p]\" .. string.gsub(w, \"%p\", \"%%%0\") .. \"[%s%p]\") then\n"
        "        speech_hit = true\n"
        "        break\n"
        "    end\n"
        "end\n"
        "if not speech_hit then\n"
        "    return true  -- None of the listed words\n"
        "end\n"
    )


@dataclass
class Result:
    action: str  # keep | speech | bribe | nogate | random-speech | manual | none
    kind: str  # trigger type label for the report
    reason: str
    src: str


def classify(attach: str, flags: set[str]) -> tuple[str, str]:
    """(action, reason) for a script with a leading gate, from the header's attach type and flags."""
    f = flags - {"GLOBAL"}
    if not f:
        return "manual", "GLOBAL only"
    if f <= CHANCE.get(attach, set()):
        return "keep", "chance"
    if attach == "MOB" and f <= SPEECH_FLAGS:
        return "speech", "word list"
    if attach == "MOB" and f == {"BRIBE"}:
        return "bribe", "minimum value"
    if attach == "MOB" and f == {"DEATH"}:
        return "nogate", "death has no roll"
    if attach == "OBJECT" and f == {"WEAR"}:
        return "nogate", "wear has no roll"
    return "manual", "mixed or undispatched trigger types"


def strip_gate(src: str, m: re.Match, replacement: str) -> str:
    """Drop the gate and the comment block directly above it that describes the bogus probability."""
    head = src[: m.start()]
    lines = head.split("\n")  # last element is "" (head ends with \n) or a partial line
    tail_idx = len(lines) - 1  # lines[:tail_idx] are complete lines
    j = tail_idx
    while j > 0 and lines[j - 1].lstrip().startswith("--"):
        j -= 1
    block = lines[j:tail_idx]
    if block and any(PROB_COMMENT_RE.search(ln) for ln in block):
        lines = lines[:j] + lines[tail_idx:]
        head = "\n".join(lines)
    return head + replacement + src[m.end():]


def fix_origin_comment(src: str, new_tail: str) -> str:
    """`-- Original: MOB trigger, flags: X, probability: 1%` is wrong once the gate is gone."""
    return re.sub(r"^(-- Original: [^\n]*?), probability: \d+%$", rf"\1, num_arg: {new_tail}", src, flags=re.M)


def replace_keyword_block(rest: str, new_block: str) -> str:
    """Swap the converter's / hand-written `if not (... speech ...) then return true end` for `new_block`.

    `rest` is the source after the gate. If there is no recognisable keyword test in the first lines,
    the block is inserted right at the start of the code (after leading comments / blank lines).
    """
    lines = rest.split("\n")
    if_idx = None
    for i, line in enumerate(lines[:25]):
        s = line.strip()
        if line.startswith("if not ") and "speech" in line:
            if_idx = i
            break
        if s == "" or s.startswith("--") or re.match(r"local speech_lower = string\.lower\(speech\)\s*$", s):
            continue
        break
    if if_idx is not None:
        end_idx = next((k for k in range(if_idx + 1, len(lines)) if lines[k] == "end"), None)
        if end_idx is not None and "return true" in "\n".join(lines[if_idx:end_idx]):
            head = [
                ln for ln in lines[:if_idx]
                if not Z.STALE_KEYWORD_COMMENT_RE.match(ln.strip())
                and not re.match(r"\s*local speech_lower = ", ln)
            ]
            while head and head[-1].strip() == "":
                head.pop()
            tail = "\n".join(lines[end_idx + 1:])
            uses_lower = re.search(r"\bspeech_lower\b", tail) is not None
            prefix = "\n".join(head) + ("\n" if head else "")
            if uses_lower:
                new_block = new_block + "local speech_lower = string.lower(speech)\n"
            return prefix + new_block + tail
    # Insert before the first code line.
    k = 0
    while k < len(lines) and (lines[k].strip() == "" or lines[k].strip().startswith("--")):
        k += 1
    prefix = "\n".join(lines[:k]) + ("\n" if k else "")
    uses_lower = re.search(r"\bspeech_lower\b", rest) is not None
    if uses_lower:
        new_block = new_block + "local speech_lower = string.lower(speech)\n"
    return prefix + new_block + "\n".join(lines[k:])


def rewrite(src: str, legacy: dict[int, Z.Legacy], zone_id: int | None = None, local_id: int | None = None) -> Result:
    m = GATE_RE.search(src)
    h = HEADER_TYPE_RE.search(src)
    if m is None or h is None:
        return Result("none", "", "", src)
    attach = h["attach"]
    flags = {x.strip() for x in h["flags"].split(",") if x.strip()}
    kind = f"{attach} {'/'.join(sorted(flags))}"
    n = int(m["n"])
    hm = Z.HEADER_RE.search(src)
    key = (int(hm["zone"]), int(hm["id"])) if hm else None
    action, why = classify(attach, flags)
    if key in OVERRIDES:
        action, why = OVERRIDES[key], "override"
    if action == "keep":
        return Result("keep", kind, why, src)
    if action == "manual" or Z.BROKEN_BODY_MARKER in src:
        return Result("manual", kind, why, src)
    if n == 0:
        # num_arg 0 is fix_percent_chance_zero.py's territory (phrase match etc.).
        return Result("manual", kind, "num_arg 0 (see fix_percent_chance_zero.py)", src)

    if action == "nogate":
        out = strip_gate(src, m, "")
        out = fix_origin_comment(out, f"{n} (no chance roll in legacy)")
        return Result("nogate", kind, why, out)

    if action == "bribe":
        if n <= 1:
            repl = ""
        else:
            repl = (
                f"-- DG BRIBE num_arg {n}: fires only when the coins are worth at least {n} copper.\n"
                f"if (value or 0) < {n} then\n"
                "    return true\n"
                "end\n"
            )
        out = strip_gate(src, m, repl)
        out = fix_origin_comment(out, f"{n} (minimum bribe in copper)")
        return Result("bribe", kind, why, out)

    lg = Z.find_legacy(src, legacy)
    if lg is None or not lg.arg.strip():
        return Result("manual", kind, "no legacy word list found", src)
    words = dg_word_list(lg.arg)
    if not words or lg.arg.strip().startswith("*"):
        return Result("manual", kind, f"unusable legacy arg {lg.arg!r}", src)

    if action == "speech":
        block = speech_block(words, f"num_arg {n}")
        # Remove the gate (and its probability comment), then place the word test.
        stripped = strip_gate(src, m, "\x00")
        head, rest = stripped.split("\x00", 1)
        out = head + replace_keyword_block(rest, block)
        out = fix_origin_comment(out, f"{n} (DG word-list mode, not a probability)")
        return Result("speech", kind, why, out)

    if action == "random-speech":
        # The body runs for SPEECH fires (speech is the text) and RANDOM fires (speech is ""); the
        # converter's single gate + keyword test blocked the RANDOM path. The RANDOM roll stays, the
        # keyword test moves to the speech path.
        stripped = strip_gate(src, m, "\x00")
        head, rest = stripped.split("\x00", 1)
        block = speech_block(words, f"num_arg {n}").rstrip("\n").split("\n")
        indented = "\n".join(("    " + ln) if ln else ln for ln in block) + "\n"
        wrapper = (
            f"-- RANDOM + SPEECH trigger (num_arg {n}): a spoken word list when someone speaks (speech is the\n"
            f"-- text), a {n}% roll on the random pulse (speech is empty).\n"
            "if speech ~= \"\" then\n"
            f"{indented}"
            f"elseif not percent_chance({n}) then\n"
            "    return true\n"
            "end\n"
        )
        # Drop the existing keyword block (which would reject every RANDOM fire) from the body.
        lines = rest.split("\n")
        if_idx = next((i for i, ln in enumerate(lines[:25]) if ln.startswith("if not ") and "speech" in ln), None)
        end_idx = None if if_idx is None else next((k for k in range(if_idx + 1, len(lines)) if lines[k] == "end"), None)
        if if_idx is None or end_idx is None:
            return Result("manual", kind, "no keyword block to replace", src)
        keep_head = [
            ln for ln in lines[:if_idx]
            if not Z.STALE_KEYWORD_COMMENT_RE.match(ln.strip()) and not re.match(r"\s*local speech_lower = ", ln)
        ]
        while keep_head and keep_head[-1].strip() == "":
            keep_head.pop()
        tail = "\n".join(lines[end_idx + 1:])
        out = head + "\n".join(keep_head) + ("\n" if keep_head else "") + wrapper + tail
        out = fix_origin_comment(out, f"{n} (word list and random chance)")
        return Result("random-speech", kind, why, out)

    return Result("manual", kind, "unhandled", src)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("paths", nargs="*", type=Path, default=[ROOT / "data" / "triggers"])
    ap.add_argument("--trg", type=Path, default=None, help="legacy lib/world/trg directory")
    ap.add_argument("--check", action="store_true", help="report only, write nothing")
    ap.add_argument("--report", type=Path, default=None, help="write the manual list here")
    args = ap.parse_args()

    trg = args.trg or Z.find_dir("lib", "world", "trg")
    if trg is None:
        sys.exit("lib/world/trg not found; pass --trg")
    legacy = Z.parse_legacy(trg)

    files: list[Path] = []
    for p in args.paths:
        files += sorted(p.rglob("*.lua")) if p.is_dir() else [p]

    counts: dict[str, collections.Counter] = collections.defaultdict(collections.Counter)
    manual: list[tuple[str, str, str]] = []
    for f in files:
        src = f.read_text(encoding="utf-8")
        out = rewrite(src, legacy)
        if out.action == "none":
            continue
        counts[out.action][out.kind] += 1
        if out.action == "manual":
            manual.append((str(f.relative_to(ROOT)) if f.is_relative_to(ROOT) else str(f), out.kind, out.reason))
        elif out.action != "keep" and out.src != src and not args.check:
            f.write_text(out.src, encoding="utf-8")
    for action in ("keep", "speech", "random-speech", "bribe", "nogate", "manual"):
        c = counts.get(action)
        if not c:
            continue
        print(f"{action}: {sum(c.values())}")
        for kind, v in sorted(c.items()):
            print(f"    {kind}: {v}")
    if args.report:
        lines = ["# Triggers whose percent_chance gate was left alone for manual review", ""]
        for rel, kind, why in sorted(manual):
            lines.append(f"- {rel} ({kind}): {why}")
        args.report.write_text("\n".join(lines) + "\n", encoding="utf-8")
    else:
        for rel, kind, why in sorted(manual):
            print(f"manual: {rel} ({kind}): {why}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
