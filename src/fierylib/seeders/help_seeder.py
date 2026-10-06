"""Authored help-file seeder for FieryMUD.

Loads hand-written help articles from markdown files (default
``data/help/*.md``) and upserts them into the ``HelpEntry`` table, or emits
an equivalent idempotent SQL file for hosts where fierylib isn't run
(production).

File format::

    ---
    keywords: [quest, quests, questing]   # first keyword is the primary key
    title: Quests
    category: guide
    min_level: 0
    usage: "quests | qaccept {zone} {id}"  # optional
    ---
    Body text, stored verbatim (plain text; hard-wrapped, no markup).

Upsert semantics mirror ``importers/help_importer.py``: an entry is matched
by its primary keyword, so a legacy entry with the same primary keyword is
overwritten by the authored one and re-running changes nothing. The match is
the row whose first keyword equals the primary keyword, falling back to the
lowest-id row that merely lists it among its keywords (the importer's
``keywords has`` lookup). ``HelpEntry`` has no unique key on keywords, so
the lookup is a SELECT inside the same unit of work.
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path
from typing import TYPE_CHECKING, Dict, Iterable, List, Optional, Sequence

if TYPE_CHECKING:  # pragma: no cover - typing only
    from prisma import Prisma

# src/fierylib/seeders/help_seeder.py -> project root is parents[3]
DEFAULT_HELP_DIR = Path(__file__).resolve().parents[3] / "data" / "help"

_KNOWN_KEYS = {"keywords", "title", "category", "min_level", "usage"}


class HelpFileError(ValueError):
    """Raised when a help markdown file is malformed."""


@dataclass
class HelpArticle:
    """One authored help entry, ready to upsert."""

    keywords: List[str]
    title: str
    content: str
    min_level: int = 0
    category: Optional[str] = None
    usage: Optional[str] = None
    source_file: str = ""

    @property
    def primary(self) -> str:
        return self.keywords[0]


# ---------------------------------------------------------------------------
# Parsing
# ---------------------------------------------------------------------------


def _unquote(value: str) -> str:
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
        inner = value[1:-1]
        if value[0] == '"':
            inner = inner.replace('\\"', '"').replace("\\\\", "\\")
        return inner
    return value


def _split_flow_list(value: str) -> List[str]:
    """Split ``[a, "b, c", d]`` on top-level commas."""
    inner = value.strip()
    if not (inner.startswith("[") and inner.endswith("]")):
        raise HelpFileError(f"expected a [list], got: {value!r}")
    inner = inner[1:-1]
    items: List[str] = []
    buf: List[str] = []
    quote = ""
    for ch in inner:
        if quote:
            buf.append(ch)
            if ch == quote:
                quote = ""
        elif ch in "\"'":
            quote = ch
            buf.append(ch)
        elif ch == ",":
            items.append("".join(buf))
            buf = []
        else:
            buf.append(ch)
    items.append("".join(buf))
    return [_unquote(i) for i in items if i.strip()]


def _parse_front_matter(block: str, where: str) -> Dict[str, object]:
    """Parse the small YAML subset the help files use.

    Supported: ``key: scalar`` (optionally quoted), ``key: [a, b]`` flow
    lists, and ``key:`` followed by ``- item`` lines. Full-line comments
    are ignored.
    """
    data: Dict[str, object] = {}
    current_list: Optional[str] = None
    for raw in block.splitlines():
        if not raw.strip() or raw.lstrip().startswith("#"):
            continue
        if raw.lstrip().startswith("- ") and current_list is not None:
            data[current_list].append(_unquote(raw.lstrip()[2:]))  # type: ignore[union-attr]
            continue
        match = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)\s*:\s*(.*)$", raw)
        if not match:
            raise HelpFileError(f"{where}: cannot parse front matter line: {raw!r}")
        key, value = match.group(1), match.group(2).strip()
        current_list = None
        if key not in _KNOWN_KEYS:
            raise HelpFileError(f"{where}: unknown front matter key {key!r}")
        if value == "":
            data[key] = []
            current_list = key
        elif value.startswith("["):
            data[key] = _split_flow_list(value)
        else:
            data[key] = _unquote(value)
    return data


def parse_help_text(text: str, source: str = "<memory>") -> HelpArticle:
    """Parse the text of one help markdown file."""
    text = text.replace("\r\n", "\n")
    if not text.startswith("---\n"):
        raise HelpFileError(f"{source}: missing '---' front matter")
    end = text.find("\n---\n", 3)
    if end == -1:
        raise HelpFileError(f"{source}: front matter is not closed with '---'")
    meta = _parse_front_matter(text[4:end], source)
    body = text[end + 5 :].strip("\n")

    raw_keywords = meta.get("keywords")
    if not isinstance(raw_keywords, list) or not raw_keywords:
        raise HelpFileError(f"{source}: 'keywords' must be a non-empty list")
    keywords: List[str] = []
    for kw in raw_keywords:
        kw = str(kw).strip().lower()
        if kw and kw not in keywords:
            keywords.append(kw)
    title = meta.get("title")
    if not isinstance(title, str) or not title.strip():
        raise HelpFileError(f"{source}: 'title' is required")
    if not body.strip():
        raise HelpFileError(f"{source}: help body is empty")
    try:
        min_level = int(str(meta.get("min_level", 0)))
    except ValueError as exc:
        raise HelpFileError(f"{source}: min_level must be an integer") from exc

    category = meta.get("category")
    usage = meta.get("usage")
    return HelpArticle(
        keywords=keywords,
        title=title.strip(),
        content=body,
        min_level=min_level,
        category=str(category).strip() or None if category is not None else None,
        usage=str(usage).strip() or None if usage is not None else None,
        source_file=source,
    )


def load_help_dir(
    help_dir: Path, categories: Optional[Sequence[str]] = None
) -> List[HelpArticle]:
    """Load every ``*.md`` file in ``help_dir`` (sorted by file name).

    ``categories`` restricts the result to those categories. Primary
    keywords must be unique across the loaded set.
    """
    help_dir = Path(help_dir)
    if not help_dir.is_dir():
        raise HelpFileError(f"help directory not found: {help_dir}")
    wanted = {c.lower() for c in categories} if categories else None
    articles: List[HelpArticle] = []
    seen: Dict[str, str] = {}
    for path in sorted(help_dir.glob("*.md")):
        art = parse_help_text(path.read_text(encoding="utf-8"), f"data/help/{path.name}")
        if wanted is not None and (art.category or "").lower() not in wanted:
            continue
        if art.primary in seen:
            raise HelpFileError(
                f"duplicate primary keyword {art.primary!r} in {path.name} and {seen[art.primary]}"
            )
        seen[art.primary] = path.name
        articles.append(art)
    return articles


# ---------------------------------------------------------------------------
# SQL emission
# ---------------------------------------------------------------------------


def _sql_str(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def _sql_opt(value: Optional[str]) -> str:
    return "NULL" if value is None else _sql_str(value)


def _dollar_quote(value: str) -> str:
    """Dollar-quote ``value`` with a tag that doesn't occur inside it."""
    tag = "help"
    n = 0
    while f"${tag}$" in value:
        n += 1
        tag = f"help{n}"
    return f"${tag}${value}${tag}$"


def render_sql(articles: Iterable[HelpArticle]) -> str:
    """Render an idempotent PostgreSQL script that upserts ``articles``.

    No explicit transaction statements are emitted, so the file can be
    wrapped by the caller (``BEGIN; \\i file; ROLLBACK;`` or
    ``psql --single-transaction``). Each entry is one DO block, atomic on
    its own, so ``psql -v ON_ERROR_STOP=1 -f`` is safe to re-run.
    """
    out: List[str] = [
        "-- Authored help guides (generated by `fierylib seed help --emit-sql`).",
        "-- Source: fierylib/data/help/*.md. Do not edit by hand; edit the markdown",
        "-- and regenerate.",
        '-- Idempotent: matches on the primary keyword ("HelpEntry" has no unique key),',
        "-- overwriting a legacy entry with the same primary keyword; re-runs change nothing",
        "-- except updated_at.",
        "",
    ]
    for art in articles:
        kw_array = "ARRAY[" + ", ".join(_sql_str(k) for k in art.keywords) + "]::text[]"
        cols = (
            f"keywords = {kw_array},\n"
            f"      title = {_sql_str(art.title)},\n"
            f"      content = {_dollar_quote(art.content)},\n"
            f"      min_level = {art.min_level},\n"
            f"      category = {_sql_opt(art.category)},\n"
            f"      usage = {_sql_opt(art.usage)},\n"
            f"      source_file = {_sql_opt(art.source_file or None)},\n"
            f"      updated_at = now()"
        )
        primary = _sql_str(art.primary)
        out.append(f"-- {art.primary}: {art.title}")
        out.append(
            "DO $do$\n"
            "DECLARE v_id integer;\n"
            "BEGIN\n"
            f'  SELECT id INTO v_id FROM "HelpEntry" WHERE keywords[1] = {primary} ORDER BY id LIMIT 1;\n'
            "  IF v_id IS NULL THEN\n"
            f'    SELECT id INTO v_id FROM "HelpEntry" WHERE {primary} = ANY(keywords) ORDER BY id LIMIT 1;\n'
            "  END IF;\n"
            "  IF v_id IS NULL THEN\n"
            '    INSERT INTO "HelpEntry"\n'
            "      (keywords, title, content, min_level, category, usage, source_file, updated_at)\n"
            "    VALUES (\n"
            f"      {kw_array},\n"
            f"      {_sql_str(art.title)},\n"
            f"      {_dollar_quote(art.content)},\n"
            f"      {art.min_level},\n"
            f"      {_sql_opt(art.category)},\n"
            f"      {_sql_opt(art.usage)},\n"
            f"      {_sql_opt(art.source_file or None)},\n"
            "      now()\n"
            "    );\n"
            "  ELSE\n"
            '    UPDATE "HelpEntry" SET\n'
            f"      {cols}\n"
            "    WHERE id = v_id;\n"
            "  END IF;\n"
            "END\n"
            "$do$;\n"
        )
    return "\n".join(out)


def emit_sql_file(articles: Sequence[HelpArticle], path: Path) -> None:
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(render_sql(articles), encoding="utf-8")


# ---------------------------------------------------------------------------
# Database seeding
# ---------------------------------------------------------------------------


class HelpSeeder:
    """Upserts authored help articles through the Prisma client."""

    def __init__(self, prisma: "Prisma"):
        self.prisma = prisma
        self.stats = {"created": 0, "updated": 0, "unchanged": 0}

    async def _find_existing(self, primary: str):
        rows = await self.prisma.query_raw(
            'SELECT id FROM "HelpEntry" WHERE keywords[1] = $1 ORDER BY id LIMIT 1', primary
        )
        if rows:
            return await self.prisma.helpentry.find_unique(where={"id": rows[0]["id"]})
        # Importer semantics: any row listing the keyword. Deterministic order.
        return await self.prisma.helpentry.find_first(
            where={"keywords": {"has": primary}}, order={"id": "asc"}
        )

    async def seed_article(self, art: HelpArticle, verbose: bool = False) -> str:
        data = {
            "keywords": art.keywords,
            "title": art.title,
            "content": art.content,
            "minLevel": art.min_level,
            "category": art.category,
            "usage": art.usage,
            "sourceFile": art.source_file or None,
        }
        existing = await self._find_existing(art.primary)
        if existing is None:
            await self.prisma.helpentry.create(data=data)  # type: ignore[arg-type]
            self.stats["created"] += 1
            result = "created"
        elif (
            list(existing.keywords or []) == art.keywords
            and existing.title == art.title
            and existing.content == art.content
            and existing.minLevel == art.min_level
            and existing.category == art.category
            and existing.usage == art.usage
            and existing.sourceFile == (art.source_file or None)
        ):
            self.stats["unchanged"] += 1
            result = "unchanged"
        else:
            await self.prisma.helpentry.update(where={"id": existing.id}, data=data)  # type: ignore[arg-type]
            self.stats["updated"] += 1
            result = "updated"
        if verbose:
            print(f"    {result}: {art.primary}")
        return result

    async def seed_all(self, articles: Sequence[HelpArticle], verbose: bool = False) -> Dict[str, int]:
        for art in articles:
            await self.seed_article(art, verbose)
        return self.stats

    async def keyword_conflicts(self, articles: Sequence[HelpArticle]) -> List[str]:
        """Describe other entries that share a keyword with a seeded one.

        Informational: in-game ``help <kw>`` lists both titles when two
        entries share a keyword (the lookup is ambiguous).
        """
        notes: List[str] = []
        for art in articles:
            rows = await self.prisma.query_raw(
                'SELECT id, title, keywords FROM "HelpEntry" '
                "WHERE keywords && $1::text[] AND NOT (keywords[1] = $2) ORDER BY id",
                art.keywords,
                art.primary,
            )
            for row in rows:
                shared = sorted(set(row["keywords"]) & set(art.keywords))
                notes.append(
                    f"{art.primary}: shares {', '.join(shared)} with "
                    f"'{row['title']}' (id {row['id']})"
                )
        return notes
