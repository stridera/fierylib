#!/usr/bin/env python3
"""Report Lua API calls in the trigger corpus that fierymud-rs does not bind.

Scans every ``data/triggers/**/*.lua`` (comments and string literals are
skipped) for three kinds of call and compares them with the names the Rust
host registers in ``crates/mud-script/src``:

  * global functions   ``name(``          vs ``globals.set("name", ..)``
  * namespace members  ``ns.name(``       vs ``<ns>_tbl.set("name", ..)``
  * methods            ``obj:name(``      vs ``add_method("name", ..)``

Usage:
    python scripts/check_trigger_api.py [--rust-src DIR] [--triggers DIR]

Exit status is 1 when anything is missing, so it can gate CI.
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

LUA_KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if",
    "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while",
}

# What the sandbox leaves of the Lua standard library (see `sandbox_lua`).
STD_GLOBALS = {
    "assert", "error", "getmetatable", "ipairs", "next", "pairs", "pcall", "rawequal", "rawget",
    "rawlen", "rawset", "select", "setmetatable", "tonumber", "tostring", "type", "xpcall",
    "unpack",
}
STD_NAMESPACES = {
    "string": {"byte", "char", "find", "format", "gmatch", "gsub", "len", "lower", "match",
               "rep", "reverse", "sub", "upper"},
    "table": {"concat", "insert", "remove", "sort", "unpack", "pack"},
    "math": {"abs", "ceil", "floor", "fmod", "huge", "max", "min", "random", "sqrt", "pi",
             "tointeger", "type", "modf", "exp", "log", "sin", "cos", "tan"},
    "os": {"time", "date", "clock", "difftime"},
    "coroutine": {"create", "resume", "yield", "status", "wrap", "isyieldable"},
}
# Methods of the string type (`s:find(..)`).
STD_METHODS = STD_NAMESPACES["string"]


def strip_lua(src: str) -> str:
    """Blank out comments and string/long-string literals, keeping newlines."""
    out: list[str] = []
    i, n = 0, len(src)
    while i < n:
        c = src[i]
        if src.startswith("--", i):
            m = re.match(r"--\[(=*)\[", src[i:])
            if m:
                close = "]" + m.group(1) + "]"
                j = src.find(close, i)
                j = n if j == -1 else j + len(close)
            else:
                j = src.find("\n", i)
                j = n if j == -1 else j
            out.append(re.sub(r"[^\n]", " ", src[i:j]))
            i = j
        elif c in "\"'":
            j = i + 1
            while j < n and src[j] != c and src[j] != "\n":
                j += 2 if src[j] == "\\" else 1
            j = min(j + 1, n)
            out.append(c + re.sub(r"[^\n]", " ", src[i + 1 : j - 1]) + c)
            i = j
        elif c == "[" and re.match(r"\[=*\[", src[i:]):
            m = re.match(r"\[(=*)\[", src[i:])
            close = "]" + m.group(1) + "]"
            j = src.find(close, i)
            j = n if j == -1 else j + len(close)
            out.append(re.sub(r"[^\n]", " ", src[i:j]))
            i = j
        else:
            out.append(c)
            i += 1
    return "".join(out)


GLOBAL_CALL = re.compile(r"(?<![\w.:])([A-Za-z_]\w*)\s*\(")
NS_CALL = re.compile(r"(?<![\w.:])([A-Za-z_]\w*)\.([A-Za-z_]\w*)\s*\(")
METHOD_CALL = re.compile(r":\s*([A-Za-z_]\w*)\s*\(")
LOCAL_FN = re.compile(r"\bfunction\s+([A-Za-z_][\w.]*)\s*\(|\blocal\s+function\s+([A-Za-z_]\w*)")
LOCAL_VAR = re.compile(r"\blocal\s+([A-Za-z_][\w, ]*?)\s*(?:=|$|\n)")
ASSIGNED_FN = re.compile(r"(?<![\w.:])([A-Za-z_]\w*)\s*=\s*function\b")


def scan_lua(code: str) -> tuple[set[str], list[str], list[tuple[str, str]], list[str]]:
    """Return (locally defined names, global calls, ns calls, method calls)."""
    local_names: set[str] = set()
    for m in LOCAL_FN.finditer(code):
        name = m.group(1) or m.group(2)
        local_names.add(name.split(".")[0])
    for m in ASSIGNED_FN.finditer(code):
        local_names.add(m.group(1))
    for m in LOCAL_VAR.finditer(code):
        for part in m.group(1).split(","):
            local_names.add(part.strip())
    # Calls like `foo(` preceded by `function ` are definitions, not calls.
    defs = {m.start(1) for m in re.finditer(r"\bfunction\s+([A-Za-z_]\w*)\s*\(", code)}
    globals_ = [m.group(1) for m in GLOBAL_CALL.finditer(code) if m.start(1) not in defs]
    ns = [(m.group(1), m.group(2)) for m in NS_CALL.finditer(code)]
    methods = [m.group(1) for m in METHOD_CALL.finditer(code)]
    return local_names, globals_, ns, methods


def registered_from_rust(src_dir: Path) -> tuple[set[str], dict[str, set[str]], set[str]]:
    """Names the host binds: (globals, {namespace: members}, methods)."""
    text = "\n".join(p.read_text(encoding="utf-8") for p in sorted(src_dir.glob("*.rs")))
    globals_ = set(re.findall(r'globals\.(?:raw_)?set\(\s*"(\w+)"', text))
    namespaces: dict[str, set[str]] = defaultdict(set)
    for tbl, member in re.findall(r'\b(\w+)_tbl\s*\.set\(\s*"(\w+)"', text):
        namespaces[tbl].add(member)
    # Namespace tables are themselves bound as globals.
    globals_ |= set(namespaces)
    methods = set(re.findall(r'add_(?:meta_)?method(?:_mut)?\(\s*"(\w+)"', text))
    # Methods forwarded through the read-only wrapper lists.
    return globals_, namespaces, methods


def check(triggers_dir: Path, src_dir: Path) -> dict[str, Counter]:
    globals_, namespaces, methods = registered_from_rust(src_dir)
    namespaces = {k: set(v) for k, v in namespaces.items()}
    for ns, members in STD_NAMESPACES.items():
        namespaces.setdefault(ns, set()).update(members)
    missing: dict[str, Counter] = {"global": Counter(), "namespace": Counter(), "method": Counter()}
    files: dict[str, set[str]] = defaultdict(set)
    for path in sorted(triggers_dir.rglob("*.lua")):
        code = strip_lua(path.read_text(encoding="utf-8"))
        local_names, g_calls, ns_calls, m_calls = scan_lua(code)
        for name in g_calls:
            if name in LUA_KEYWORDS or name in STD_GLOBALS or name in local_names:
                continue
            if name in globals_:
                continue
            missing["global"][name] += 1
            files[f"global:{name}"].add(path.name)
        for ns, member in ns_calls:
            if ns in local_names:
                continue  # a script-local table, not an API namespace
            if member in namespaces.get(ns, ()):
                continue
            key = f"{ns}.{member}"
            missing["namespace"][key] += 1
            files[f"namespace:{key}"].add(path.name)
        for name in m_calls:
            if name in methods or name in STD_METHODS:
                continue
            missing["method"][name] += 1
            files[f"method:{name}"].add(path.name)
    check.files = files  # type: ignore[attr-defined]
    return missing


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--triggers", type=Path, default=ROOT / "data" / "triggers")
    ap.add_argument(
        "--rust-src",
        type=Path,
        default=ROOT.parent / "fierymud-rs" / "crates" / "mud-script" / "src",
    )
    args = ap.parse_args(argv)
    if not args.rust_src.is_dir():
        print(f"error: Rust binding sources not found at {args.rust_src}", file=sys.stderr)
        return 2
    missing = check(args.triggers, args.rust_src)
    files = check.files  # type: ignore[attr-defined]
    total = 0
    for kind in ("global", "namespace", "method"):
        if not missing[kind]:
            continue
        print(f"\nMissing {kind} bindings:")
        for name, calls in sorted(missing[kind].items(), key=lambda kv: (-kv[1], kv[0])):
            nfiles = len(files[f"{kind}:{name}"])
            print(f"  {name:<32} {calls:>4} calls  {nfiles:>3} scripts")
            total += 1
    if total == 0:
        print("All trigger API calls are bound.")
    return 1 if total else 0


if __name__ == "__main__":
    sys.exit(main())
