"""
Custom Item Analyzer — Analyzes vnum -1 (custom) items from player .objs files
and attempts to match them to existing object prototypes in the database.

Custom items are typically renamed versions of existing items — players changed
the name/description but the underlying properties remain identical or similar.
"""

import json
from dataclasses import dataclass, field
from pathlib import Path

from mud.mudfile import MudData
from mud.parser import Parser
from mud.types import MudTypes, Extras
from mud.types.object import Object


@dataclass
class MatchResult:
    """Result of matching a custom item to a prototype."""
    zone_id: int
    obj_id: int
    name: str
    score: int
    deltas: list[str]


@dataclass
class CustomItem:
    """A custom item parsed from a player's .objs file."""
    player_name: str
    obj: Object
    location: int
    best_match: MatchResult | None = None


@dataclass
class AnalysisReport:
    """Complete analysis report."""
    total_items: int = 0
    mail_skipped: int = 0
    corpse_skipped: int = 0
    analyzed: int = 0
    confident: list[CustomItem] = field(default_factory=list)
    tentative: list[CustomItem] = field(default_factory=list)
    unmatched: list[CustomItem] = field(default_factory=list)


def parse_custom_items_from_file(file_path: Path, player_name: str) -> list[tuple[Object, int]]:
    """Parse all vnum -1 items from a single .objs file.

    Returns list of (Object, location) tuples.
    """
    items = []
    try:
        with open(file_path, "r", encoding="ascii", errors="replace") as f:
            content = f.read()
    except Exception:
        return items

    lines = content.split("\n")
    if not lines or lines[0].strip() != "1":
        return items

    # Split by ~~ delimiter (same as Object.parse_player)
    blocks = content.split("~~\n")

    parser = Parser(MudTypes.OBJECT)

    for block in blocks[1:]:  # Skip the version block
        if not block.strip():
            continue

        # Quick check: is this a vnum -1 block?
        has_vnum_minus_1 = False
        for line in block.split("\n"):
            stripped = line.strip()
            if stripped.startswith("vnum:"):
                val = stripped.split(":", 1)[1].strip()
                if val == "-1":
                    has_vnum_minus_1 = True
                break

        if not has_vnum_minus_1:
            continue

        # Parse the block using the Parser
        try:
            block_lines = block.split("\n")
            mud_data = MudData(block_lines)
            parsed_data = parser.parse(mud_data)

            location = parsed_data.pop("location", 127)
            mapped = Object._map_parser_fields(parsed_data)

            # Ensure we have an id field
            if "id" not in mapped:
                mapped["id"] = -1

            obj = Object(**mapped)
            items.append((obj, location))
        except Exception:
            # Skip unparseable blocks
            continue

    return items


def is_mail(obj: Object) -> bool:
    """Check if an item is mail (type NOTE)."""
    return obj.type is not None and obj.type.upper() == "NOTE"


def is_corpse(obj: Object) -> bool:
    """Check if an item is a corpse (container with IsCorpse flag)."""
    if obj.type is None or obj.type.upper() != "CONTAINER":
        return False
    if obj.values and isinstance(obj.values, dict):
        return bool(obj.values.get("IsCorpse", False))
    return False


def compute_match_score(custom: Object, proto: dict) -> tuple[int, list[str]]:
    """Compute a match score between a custom item and a database prototype.

    Args:
        custom: The custom Object parsed from a player file
        proto: A dict from the database with keys: type, values, weight, cost,
               level, flags, wearFlags, name, keywords, affects

    Returns:
        (score, list of delta descriptions)
    """
    score = 0
    deltas = []

    # Values match (strongest signal — type-specific stats)
    custom_values = custom.values or {}
    proto_values = proto.get("values") or {}

    if custom_values and proto_values:
        if _values_equal(custom_values, proto_values):
            score += 40
        else:
            deltas.append("values")
    elif not custom_values and not proto_values:
        score += 40  # Both empty — match

    # Applies match (stat bonuses)
    custom_applies = _normalize_applies(custom.applies)
    proto_applies = _normalize_applies(proto.get("affects"))

    if custom_applies == proto_applies:
        score += 30
    elif custom_applies and proto_applies:
        # Partial match — check overlap
        overlap = set(custom_applies.items()) & set(proto_applies.items())
        if len(overlap) >= len(custom_applies) * 0.5:
            score += 15
        deltas.append("applies")
    elif custom_applies or proto_applies:
        deltas.append("applies")

    # Wear flags match
    custom_wear = set(custom.wear_flags or [])
    proto_wear = set(proto.get("wearFlags") or [])

    if custom_wear == proto_wear:
        score += 15
    else:
        deltas.append("wear")

    # Weight match
    custom_weight = custom.weight or 0
    proto_weight = proto.get("weight", 0) or 0

    if abs(custom_weight - proto_weight) < 0.01:
        score += 10
    elif proto_weight > 0 and abs(custom_weight - proto_weight) / max(proto_weight, 1) <= 0.2:
        score += 5
        deltas.append("weight")
    else:
        deltas.append("weight")

    # Level match
    custom_level = custom.level or 0
    proto_level = proto.get("level", 0) or 0

    if custom_level == proto_level:
        score += 10
    elif abs(custom_level - proto_level) <= 5:
        score += 5
        deltas.append("level")
    else:
        deltas.append("level")

    # Cost match
    custom_cost = custom.cost or 0
    proto_cost = proto.get("cost", 0) or 0

    if custom_cost == proto_cost:
        score += 5
    else:
        deltas.append(f"cost ({proto_cost}→{custom_cost})")

    # Flags match
    custom_flags = set(custom.flags or [])
    proto_flags = set(proto.get("flags") or [])

    if custom_flags == proto_flags:
        score += 10
    else:
        deltas.append("flags")

    # Keyword overlap (weak signal — names are what changed)
    custom_kw = set(k.lower() for k in (custom.keywords or []))
    proto_kw = set(k.lower() for k in (proto.get("keywords") or []))

    if custom_kw and proto_kw:
        intersection = custom_kw & proto_kw
        union = custom_kw | proto_kw
        jaccard = len(intersection) / len(union) if union else 0
        if jaccard > 0.5:
            score += 5
        else:
            deltas.append("keywords")
    else:
        deltas.append("keywords")

    # Short description match (very weak — almost always different)
    custom_short = (custom.short or "").lower().strip()
    proto_short = (proto.get("name") or "").lower().strip()

    if custom_short and proto_short and custom_short == proto_short:
        score += 5
    else:
        deltas.append("name")

    return score, deltas


def _values_equal(a: dict, b: dict) -> bool:
    """Compare two values dicts, tolerating type differences (int vs str)."""
    if not a and not b:
        return True
    if not a or not b:
        return False

    # Compare by key — both should have the same keys and values
    if set(a.keys()) != set(b.keys()):
        return False

    for key in a:
        va, vb = a[key], b[key]
        # Try numeric comparison
        try:
            if float(va) != float(vb):
                return False
        except (ValueError, TypeError):
            if str(va) != str(vb):
                return False
    return True


def _normalize_applies(applies) -> dict[str, int]:
    """Normalize applies/affects into a comparable dict.

    Handles both custom item format (dict of str→int from parser)
    and database format (list of {location, modifier} dicts).
    """
    if not applies:
        return {}

    result = {}
    if isinstance(applies, dict):
        # Parser output format: {"ApplyTypes.HitRoll": 3, ...}
        for key, val in applies.items():
            # Normalize key — strip enum prefix if present
            k = str(key)
            if "." in k:
                k = k.split(".")[-1]
            result[k.upper()] = int(val)
    elif isinstance(applies, list):
        # Database format: [{"location": "HITROLL", "modifier": 3}, ...]
        for entry in applies:
            if isinstance(entry, dict):
                loc = entry.get("location", "")
                mod = entry.get("modifier", 0)
                result[loc.upper()] = int(mod)
    return result


async def find_candidates(prisma, obj_type: str) -> list[dict]:
    """Query database for all objects of the given type.

    Returns a list of dicts with the fields needed for scoring.
    """
    # Normalize type to match Prisma enum (e.g., "ARMOR" → "ARMOR")
    normalized_type = obj_type.upper().strip()

    # Handle special type name mappings
    type_map = {
        "DRINKCON": "DRINK_CONTAINER",
        "DRINKCONTAINER": "DRINK_CONTAINER",
    }
    normalized_type = type_map.get(normalized_type, normalized_type)

    try:
        results = await prisma.objects.find_many(
            where={"type": normalized_type},
            include={"objectAffects": True},
        )
    except Exception:
        return []

    candidates = []
    for r in results:
        affects = []
        if r.objectAffects:
            affects = [{"location": a.location, "modifier": a.modifier} for a in r.objectAffects]

        candidates.append({
            "zoneId": r.zoneId,
            "id": r.id,
            "type": r.type,
            "values": r.values if isinstance(r.values, dict) else (json.loads(r.values) if isinstance(r.values, str) else {}),
            "weight": r.weight,
            "cost": r.cost,
            "level": r.level,
            "flags": list(r.flags) if r.flags else [],
            "wearFlags": list(r.wearFlags) if r.wearFlags else [],
            "name": r.name,
            "keywords": list(r.keywords) if r.keywords else [],
            "affects": affects,
        })

    return candidates


async def analyze_custom_items(
    prisma,
    players_dir: str,
    verbose: bool = False,
    json_output: str | None = None,
) -> AnalysisReport:
    """Main analysis entry point.

    Scans all .objs files, parses custom items, matches to prototypes.
    """
    report = AnalysisReport()

    players_path = Path(players_dir)
    if not players_path.exists():
        raise FileNotFoundError(f"Players directory not found: {players_dir}")

    # Collect all custom items
    all_custom_items: list[CustomItem] = []
    objs_files = sorted(players_path.rglob("*.objs"))

    for objs_file in objs_files:
        player_name = objs_file.stem
        parsed = parse_custom_items_from_file(objs_file, player_name)
        for obj, location in parsed:
            report.total_items += 1

            if is_mail(obj):
                report.mail_skipped += 1
                continue

            if is_corpse(obj):
                report.corpse_skipped += 1
                continue

            all_custom_items.append(CustomItem(
                player_name=player_name,
                obj=obj,
                location=location,
            ))

    report.analyzed = len(all_custom_items)

    # Cache candidates by type to avoid redundant queries
    type_cache: dict[str, list[dict]] = {}

    for item in all_custom_items:
        obj_type = (item.obj.type or "NOTHING").upper()

        if obj_type not in type_cache:
            if verbose:
                print(f"  Querying candidates for type: {obj_type}")
            type_cache[obj_type] = await find_candidates(prisma, obj_type)

        candidates = type_cache[obj_type]

        best_score = -1
        best_match = None
        best_deltas = []

        for cand in candidates:
            score, deltas = compute_match_score(item.obj, cand)
            if score > best_score:
                best_score = score
                best_match = cand
                best_deltas = deltas

        if best_match:
            item.best_match = MatchResult(
                zone_id=best_match["zoneId"],
                obj_id=best_match["id"],
                name=best_match["name"],
                score=best_score,
                deltas=best_deltas,
            )

        # Classify
        if best_score >= 50:
            report.confident.append(item)
        elif best_score >= 30:
            report.tentative.append(item)
        else:
            report.unmatched.append(item)

    # Sort each category by score descending
    report.confident.sort(key=lambda x: x.best_match.score if x.best_match else 0, reverse=True)
    report.tentative.sort(key=lambda x: x.best_match.score if x.best_match else 0, reverse=True)
    report.unmatched.sort(key=lambda x: x.best_match.score if x.best_match else 0, reverse=True)

    # Write JSON output if requested
    if json_output:
        _write_json_report(report, json_output)

    return report


def print_report(report: AnalysisReport):
    """Print a human-readable report to stdout."""
    print(f"\n{'='*60}")
    print(f"  Custom Item Analysis Report")
    print(f"{'='*60}")
    print(f"\nSkipped: {report.mail_skipped} mail items, {report.corpse_skipped} corpses")
    print(f"Analyzed: {report.analyzed} items")

    # Confident matches
    print(f"\n--- Confident Matches (score >= 50): {len(report.confident)} items ---")
    for item in report.confident:
        m = item.best_match
        obj = item.obj
        print(f'  Player: {item.player_name} | "{obj.short}" ({obj.type}, lvl {obj.level or "?"})')
        if m:
            print(f'    -> Matched: zone {m.zone_id} id {m.obj_id} "{m.name}" (score: {m.score})')
            if m.deltas:
                print(f"    -> Delta: {', '.join(m.deltas)}")

    # Tentative matches
    print(f"\n--- Tentative Matches (score 30-49): {len(report.tentative)} items ---")
    for item in report.tentative:
        m = item.best_match
        obj = item.obj
        print(f'  Player: {item.player_name} | "{obj.short}" ({obj.type}, lvl {obj.level or "?"})')
        if m:
            print(f'    -> Matched: zone {m.zone_id} id {m.obj_id} "{m.name}" (score: {m.score})')
            if m.deltas:
                print(f"    -> Delta: {', '.join(m.deltas)}")

    # Unmatched
    print(f"\n--- Unmatched Items (score < 30): {len(report.unmatched)} items ---")
    for item in report.unmatched:
        m = item.best_match
        obj = item.obj
        print(f'  Player: {item.player_name} | "{obj.short}" ({obj.type}, lvl {obj.level or "?"})')
        if m:
            print(f'    -> Best candidate: zone {m.zone_id} id {m.obj_id} "{m.name}" (score: {m.score})')
        else:
            print(f"    -> No candidates found")

    # Deduplicated unmatched summary
    unmatched_fingerprints: dict[str, list[str]] = {}
    for item in report.unmatched:
        obj = item.obj
        # Fingerprint by type + values + applies
        fp = f"{obj.type}|{json.dumps(obj.values, sort_keys=True, default=str)}|{json.dumps(obj.applies, sort_keys=True, default=str)}"
        if fp not in unmatched_fingerprints:
            unmatched_fingerprints[fp] = []
        unmatched_fingerprints[fp].append(item.player_name)

    # Summary
    print(f"\n--- Summary ---")
    print(f"Total custom items: {report.total_items}")
    print(f"Confident matches: {len(report.confident)} items")
    print(f"Tentative matches: {len(report.tentative)} items")
    print(f"Unmatched: {len(report.unmatched)} items")
    print(f"Unique unmatched prototypes (deduplicated): {len(unmatched_fingerprints)} items")


def _write_json_report(report: AnalysisReport, path: str):
    """Write the report as JSON."""
    def item_to_dict(item: CustomItem) -> dict:
        obj = item.obj
        result = {
            "player": item.player_name,
            "location": item.location,
            "name": obj.short,
            "type": obj.type,
            "level": obj.level,
            "weight": obj.weight,
            "cost": obj.cost,
            "keywords": obj.keywords,
            "values": obj.values,
            "applies": obj.applies,
            "flags": obj.flags,
            "wear_flags": obj.wear_flags,
        }
        if item.best_match:
            m = item.best_match
            result["match"] = {
                "zone_id": m.zone_id,
                "obj_id": m.obj_id,
                "name": m.name,
                "score": m.score,
                "deltas": m.deltas,
            }
        return result

    data = {
        "total_items": report.total_items,
        "mail_skipped": report.mail_skipped,
        "corpse_skipped": report.corpse_skipped,
        "analyzed": report.analyzed,
        "confident": [item_to_dict(i) for i in report.confident],
        "tentative": [item_to_dict(i) for i in report.tentative],
        "unmatched": [item_to_dict(i) for i in report.unmatched],
        "summary": {
            "confident_count": len(report.confident),
            "tentative_count": len(report.tentative),
            "unmatched_count": len(report.unmatched),
        },
    }

    with open(path, "w") as f:
        json.dump(data, f, indent=2, default=str)
    print(f"\nJSON report written to: {path}")
