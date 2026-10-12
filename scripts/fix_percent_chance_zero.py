#!/usr/bin/env python3
"""Remove the converter's dead `percent_chance(0)` guard from the trigger corpus (data/triggers).

The DG-to-Lua converter treated a trigger's numeric argument as a probability and emitted

    if not percent_chance(0) then
        return true
    end

for every trigger whose num_arg is 0. That guard is always false, so the whole body was blocked.
But num_arg only means "probability" for a few trigger types. What it means is read from the legacy
DG source (lib/world/trg/<zone>.trg), found through the `Original DG Script: #<vnum>` header line:

  SPEECH / SPEECH_TO (d, n)  num_arg 0 = the speech must contain the arg as a phrase (is_substring in
                             dg_triggers.cpp). The converter also split that phrase into an OR of
                             single-word `string.find`s, which matches almost any sentence. Both the
                             guard and the keyword block are replaced by one phrase test.
  RECEIVE (j)                no chance roll at all. num_arg 0 means "fire unless the item vnum is on the
                             arg list" (those items are handled by other triggers). The runtime does not
                             filter on arg_list, so the exclusion is added to the body.
  WORLD GLOBAL (a)           only run through run_room_trigger(); the guard just blocked those calls.
  DEATH (f)                  fires on every death, no chance roll.

Everything else is listed as manual and left alone: RANDOM (num_arg 0 really means "never"), ACT (the
runtime does not dispatch it), test scripts, and bodies marked "Leaving the body intact for later
rewrite" (removing the guard would run code known to error out).

Usage:
    python scripts/fix_percent_chance_zero.py [--check] [--trg DIR] [--zon DIR] [--manual-out FILE] [PATH ...]

PATH may be files or directories (default: data/triggers). --check reports without writing.
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))
sys.path.insert(0, str(ROOT / "scripts"))

# `-- 0% chance to trigger` (converter) or `-- Disabled by legacy 0% probability ...` may sit above the guard.
GUARD_RE = re.compile(
    r"(?P<comment>^[ \t]*--[^\n]*(?:chance to trigger|Disabled by legacy 0%)[^\n]*\n)?"
    r"^if not percent_chance\(0\) then\n[ \t]+return true\n^end\n",
    re.M,
)
VNUM_RE = re.compile(r"Original DG Script: #(\d+)")
HEADER_RE = re.compile(r"^-- Trigger: (?P<name>.*)\n-- Zone: (?P<zone>\d+), ID: (?P<id>\d+)", re.M)
BROKEN_BODY_MARKER = "Leaving the body intact for later rewrite"
STALE_KEYWORD_COMMENT_RE = re.compile(
    r"^-- (?:Speech keywords\b|TODO\(parity\): original DG keyword|converter split it into|Should require all keywords)"
)

FLAG_NAMES = {
    0: {"a": "GLOBAL", "b": "RANDOM", "c": "COMMAND", "d": "SPEECH", "e": "ACT", "f": "DEATH", "g": "GREET",
        "h": "GREET_ALL", "i": "ENTRY", "j": "RECEIVE", "k": "FIGHT", "l": "HITPRCNT", "m": "BRIBE",
        "n": "SPEECH_TO", "o": "LOAD", "p": "MEMORY", "q": "CAST", "r": "LEAVE", "s": "DOOR"},
    2: {"a": "GLOBAL", "b": "RANDOM", "c": "COMMAND", "d": "SPEECH", "e": "ZONE_RESET", "f": "RESET",
        "g": "PREENTRY", "h": "POSTENTRY"},
}


# --------------------------------------------------------------------------------------
# Legacy source
# --------------------------------------------------------------------------------------


@dataclass
class Legacy:
    vnum: int
    name: str
    attach: int  # 0 mob, 1 object, 2 world
    flags: str
    narg: int
    arg: str


LEGACY_RE = re.compile(
    r"^#(?P<vnum>\d+)\n(?P<name>[^\n]*)~\n(?P<attach>\d+) (?P<flags>\S+) (?P<narg>-?\d+)\n(?P<arg>.*?)~\n",
    re.M | re.S,
)


def parse_legacy(trg_dir: Path) -> dict[int, Legacy]:
    out: dict[int, Legacy] = {}
    for f in sorted(trg_dir.glob("*.trg")):
        text = f.read_text(encoding="latin-1")
        for m in LEGACY_RE.finditer(text):
            out[int(m["vnum"])] = Legacy(
                int(m["vnum"]), m["name"].strip(), int(m["attach"]), m["flags"], int(m["narg"]), m["arg"].strip()
            )
    return out


def flag_label(lg: Legacy) -> str:
    names = FLAG_NAMES.get(lg.attach, {})
    return "/".join(names.get(c, c) for c in lg.flags)


# --------------------------------------------------------------------------------------
# Rewriting
# --------------------------------------------------------------------------------------


@dataclass
class Outcome:
    kind: str  # fixed-speech fixed-receive fixed-global fixed-death manual none
    reason: str
    src: str


def lua_str(s: str) -> str:
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def _vnum_to_composite(v: int, ranges):
    import fix_trigger_patterns as F

    return F.vnum_to_composite(v, ranges)


def _replace_guard(src: str, m: re.Match, new: str) -> str:
    return src[: m.start()] + new + src[m.end():]


def _rewrite_speech(src: str, m: re.Match, phrase: str) -> str | None:
    """Replace the guard and the converter's keyword block with one phrase test; None if no keyword block."""
    rest = src[m.end():]
    lines = rest.split("\n")
    # The keyword `if not (...speech...) then ... end` must follow the guard directly (blank lines,
    # comments and `local speech_lower = ...` aside).
    if_idx = None
    for i, line in enumerate(lines[:25]):
        s = line.strip()
        if line.startswith("if not ") and "speech" in line:
            if_idx = i
            break
        if s == "" or s.startswith("--") or re.match(r"local speech_lower = string\.lower\(speech\)\s*$", s):
            continue
        return None
    if if_idx is None:
        return None
    end_idx = next((j for j in range(if_idx + 1, len(lines)) if lines[j] == "end"), None)
    if end_idx is None or "return true" not in "\n".join(lines[if_idx:end_idx]):
        return None
    kept_head = [
        ln
        for ln in lines[:if_idx]
        if not STALE_KEYWORD_COMMENT_RE.match(ln.strip()) and not re.match(r"\s*local speech_lower = ", ln)
    ]
    # drop blank lines directly left behind at the end of the kept head
    while kept_head and kept_head[-1].strip() == "":
        kept_head.pop()
    tail = "\n".join(lines[end_idx + 1:])
    uses_lower = re.search(r"\bspeech_lower\b", tail) is not None
    target = "speech_lower" if uses_lower else "string.lower(speech)"
    block = [f"-- Speech phrase: {phrase} (DG num_arg 0 = the speech contains the phrase, not a chance)"]
    if uses_lower:
        block.append("local speech_lower = string.lower(speech)")
    block += [
        f"if not string.find({target}, {lua_str(phrase.lower())}, 1, true) then",
        "    return true  -- Not the phrase",
        "end",
    ]
    new_rest = "\n".join(kept_head + block) + "\n" + tail
    return src[: m.start()] + new_rest


def _receive_exclusion(vnums: list[int], ranges) -> tuple[str, list[int]]:
    clauses: list[str] = []
    bad: list[int] = []
    for v in vnums:
        zl = _vnum_to_composite(v, ranges)
        if zl is None:
            bad.append(v)
            continue
        clauses.append(f"(object.zone_id == {zl[0]} and object.id == {zl[1]})")
    if not clauses:
        return "", bad
    cond = clauses[0] if len(clauses) == 1 else "\n    or ".join(clauses)
    text = (
        "-- DG receive trigger, num_arg 0: the arg list (" + " ".join(str(v) for v in vnums) + ") holds the items\n"
        "-- other triggers handle; this one runs for every other item. The runtime does not filter on\n"
        "-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)\n"
        f"if {cond} then\n"
        "    return true\n"
        "end\n"
    )
    return text, bad


def _norm(name: str) -> str:
    return re.sub(r"[^a-z0-9]+", "", name.lower())


def find_legacy(src: str, legacy: dict[int, Legacy]) -> Legacy | None:
    """By the `Original DG Script: #vnum` line, else by zone*100+id when the legacy name agrees."""
    vm = VNUM_RE.search(src)
    if vm:
        return legacy.get(int(vm[1]))
    hm = HEADER_RE.search(src)
    if hm:
        lg = legacy.get(int(hm["zone"]) * 100 + int(hm["id"]))
        if lg is not None and _norm(lg.name) == _norm(hm["name"]):
            return lg
    return None


def rewrite(src: str, legacy: dict[int, Legacy], ranges, path: str = "<mem>") -> Outcome:
    m = GUARD_RE.search(src)
    if m is None:
        return Outcome("none", "", src)
    lg = find_legacy(src, legacy)
    if lg is None:
        return Outcome("manual", "no legacy DG source found for this trigger", src)
    label = f"legacy {flag_label(lg)} num_arg {lg.narg}"
    if BROKEN_BODY_MARKER in src:
        return Outcome("manual", f"{label}: the body is documented as broken; removing the guard would run it", src)
    if lg.narg != 0:
        return Outcome("manual", f"{label}: num_arg is not 0, so this guard is not the known defect", src)
    flags = set(lg.flags)

    if lg.attach in (0, 2) and flags and flags <= {"d", "n"} and lg.arg:
        new = _rewrite_speech(src, m, lg.arg)
        if new is None:
            return Outcome("manual", f"{label}: no keyword block after the guard to replace", src)
        return Outcome("fixed-speech", f"phrase {lg.arg!r}", new)

    if lg.attach == 0 and flags == {"j"}:
        vnums = [int(x) for x in lg.arg.split() if x.isdigit()]
        if not vnums:
            return Outcome("fixed-receive", "no arg list", _replace_guard(src, m, ""))
        excl, bad = _receive_exclusion(vnums, ranges)
        if bad:
            return Outcome("manual", f"{label}: vnums {bad} are outside every zone range", src)
        return Outcome("fixed-receive", f"excludes {len(vnums)} items", _replace_guard(src, m, excl))

    if lg.attach == 2 and flags == {"a"}:
        note = (
            "-- Runs only through run_room_trigger() (DG probability 0 = never automatic); the converter's\n"
            "-- percent_chance(0) guard blocked those calls.\n"
        )
        return Outcome("fixed-global", "world global", _replace_guard(src, m, note))

    if lg.attach == 0 and flags == {"f"}:
        note = "-- DG death triggers have no chance roll; the converter's percent_chance(0) guard is gone.\n"
        return Outcome("fixed-death", "death", _replace_guard(src, m, note))

    why = {
        "b": "RANDOM: num_arg 0 means it never fires in legacy, so the guard is correct",
        "e": "ACT: the runtime does not dispatch ACT triggers and has no act-text variable to match",
    }
    detail = next((why[c] for c in lg.flags if c in why), "not a trigger type with a known num_arg meaning")
    return Outcome("manual", f"{label}: {detail}", src)


# --------------------------------------------------------------------------------------
# Driver
# --------------------------------------------------------------------------------------


def find_dir(*parts: str) -> Path | None:
    for p in ROOT.parents:
        if (p.joinpath(*parts)).is_dir():
            return p.joinpath(*parts)
    return None


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("paths", nargs="*", type=Path, default=[ROOT / "data" / "triggers"])
    ap.add_argument("--trg", type=Path, default=None, help="legacy lib/world/trg directory")
    ap.add_argument("--zon", type=Path, default=None, help="lib/world/zon directory")
    ap.add_argument("--check", action="store_true", help="report only, write nothing")
    ap.add_argument("--manual-out", type=Path, default=None, help="write the manual list here")
    args = ap.parse_args()

    from fierylib.converters.dg_to_lua import build_zone_ranges

    trg = args.trg or find_dir("lib", "world", "trg")
    zon = args.zon or find_dir("lib", "world", "zon")
    if trg is None or zon is None:
        sys.exit("lib/world/trg or lib/world/zon not found; pass --trg / --zon")
    legacy = parse_legacy(trg)
    ranges = build_zone_ranges(zon)
    if not legacy or not ranges:
        sys.exit("no legacy triggers or zone ranges found")

    files: list[Path] = []
    for p in args.paths:
        files += sorted(p.rglob("*.lua")) if p.is_dir() else [p]

    counts: dict[str, int] = {}
    manual: list[tuple[str, str]] = []
    for f in files:
        src = f.read_text(encoding="utf-8")
        rel = str(f.relative_to(ROOT)) if f.is_relative_to(ROOT) else str(f)
        out = rewrite(src, legacy, ranges, rel)
        if out.kind == "none":
            continue
        counts[out.kind] = counts.get(out.kind, 0) + 1
        if out.kind == "manual":
            manual.append((rel, out.reason))
        elif out.src != src and not args.check:
            f.write_text(out.src, encoding="utf-8")
    fixed = sum(v for k, v in counts.items() if k.startswith("fixed"))
    print(f"files scanned {len(files)} | fixed {fixed} ({', '.join(f'{k[6:]} {v}' for k, v in sorted(counts.items()) if k.startswith('fixed'))}) | manual {len(manual)}")
    if args.manual_out:
        lines = [
            "# Triggers that still carry `percent_chance(0)`",
            "",
            "Generated by `scripts/fix_percent_chance_zero.py --check --manual-out`. Each of these has a guard",
            "that the rewriter deliberately did not remove; the reason is the legacy DG trigger type.",
            "",
        ]
        reasons: dict[str, list[str]] = {}
        for rel, why in manual:
            reasons.setdefault(why.split(": ", 1)[-1] if "legacy" in why else why, []).append(rel)
        for why, rels in sorted(reasons.items(), key=lambda kv: -len(kv[1])):
            lines.append(f"## {why} ({len(rels)})")
            lines += [f"- {r}" for r in sorted(rels)]
            lines.append("")
        args.manual_out.write_text("\n".join(lines), encoding="utf-8")
    else:
        for rel, why in manual:
            print(f"  manual {rel}: {why}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
