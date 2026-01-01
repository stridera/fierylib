#!/usr/bin/env python3
"""
Add sphere-based colors to spell descriptions.

Color scheme:
- FIRE: <b:red> for fire/flame/burn keywords
- COLD/WATER: <b:cyan> for ice/frost/cold keywords
- AIR/SHOCK: <b:yellow> for lightning/shock/thunder keywords
- EARTH: <green> for earth/stone/nature keywords
- HEALING: <healing> for heal/cure/restore keywords
- DEATH: <magenta> for death/undead/necrotic keywords
- PROTECTION: <b:blue> for protect/shield/ward keywords
- ENCHANTMENT: <b:magenta> for charm/enchant/control keywords
- SUMMONING: <magenta> for summon/conjure/portal keywords
- DIVINATION: <cyan> for detect/reveal/see keywords
"""

import json
import re
from pathlib import Path
from typing import Dict, List, Tuple

# Sphere to color and keyword mappings
SPHERE_COLORS = {
    "FIRE": {
        "color": "b:red",
        "keywords": [
            r"\bfire\b", r"\bflame\b", r"\bflames\b", r"\bburn\b", r"\bburning\b",
            r"\bburns\b", r"\bblaze\b", r"\binferno\b", r"\bscorch\b", r"\bsear\b",
            r"\bimmolate\b", r"\bcombust\b", r"\bpyre\b", r"\bembers?\b", r"\bashes\b",
        ],
    },
    "COLD": {
        "color": "b:cyan",
        "keywords": [
            r"\bice\b", r"\bicy\b", r"\bfrost\b", r"\bfrosty\b", r"\bcold\b",
            r"\bfreeze\b", r"\bfreezing\b", r"\bfrozen\b", r"\bchilling?\b",
            r"\bblizzard\b", r"\bwinter\b", r"\bglacial\b", r"\bsnow\b",
        ],
    },
    "WATER": {
        "color": "cyan",
        "keywords": [
            r"\bwater\b", r"\bwave\b", r"\bflood\b", r"\bocean\b", r"\bsea\b",
            r"\btide\b", r"\bdrown\b", r"\baquatic\b", r"\bdeluge\b", r"\btorrent\b",
        ],
    },
    "AIR": {
        "color": "b:yellow",
        "keywords": [
            r"\blightning\b", r"\bthunder\b", r"\bshock\b", r"\belectri\w*\b",
            r"\bbolt\b", r"\bstorm\b", r"\bwind\b", r"\bgust\b", r"\btornado\b",
            r"\bspark\b", r"\bzap\b", r"\bsurge\b",
        ],
    },
    "EARTH": {
        "color": "green",
        "keywords": [
            r"\bearth\b", r"\bstone\b", r"\brock\b", r"\bground\b", r"\bquake\b",
            r"\bboulder\b", r"\bmountain\b", r"\bgravel\b", r"\bsand\b", r"\bdirt\b",
            r"\bnature\b", r"\bvine\b", r"\broot\b", r"\bthorns?\b", r"\bbark\b",
        ],
    },
    "HEALING": {
        "color": "healing",
        "keywords": [
            r"\bheal\b", r"\bheals\b", r"\bhealing\b", r"\bcure\b", r"\bcures\b",
            r"\bcuring\b", r"\brestore\b", r"\brestores\b", r"\brestoring\b",
            r"\bmend\b", r"\bsoothe\b", r"\brevitalize\b", r"\brejuvenate\b",
            r"\brecuperate\b", r"\brecovery\b", r"\bwounds?\b",
        ],
    },
    "DEATH": {
        "color": "magenta",
        "keywords": [
            r"\bdeath\b", r"\bdead\b", r"\bdie\b", r"\bundead\b", r"\bnecrotic\b",
            r"\bsoul\b", r"\bsouls\b", r"\bspirit\b", r"\bgrave\b", r"\bcorpse\b",
            r"\bbone\b", r"\bbones\b", r"\bskeleton\b", r"\bzombie\b", r"\bwraith\b",
            r"\bdecay\b", r"\bwither\b", r"\bdrain\b", r"\bdrains\b",
        ],
    },
    "PROTECTION": {
        "color": "b:blue",
        "keywords": [
            r"\bprotect\b", r"\bprotection\b", r"\bshield\b", r"\bward\b",
            r"\barmor\b", r"\bdefend\b", r"\bdefense\b", r"\bbarrier\b",
            r"\bguard\b", r"\bfortify\b", r"\babsorb\b",
        ],
    },
    "ENCHANTMENT": {
        "color": "b:magenta",
        "keywords": [
            r"\bcharm\b", r"\benchant\b", r"\bcontrol\b", r"\bmind\b",
            r"\bhypnotize\b", r"\bmesmerize\b", r"\bconfuse\b", r"\bconfusion\b",
            r"\bblind\b", r"\bdeafen\b", r"\bsilence\b", r"\bwebs?\b", r"\bentangle\b",
            r"\bimmobilize\b", r"\bsticky\b",
        ],
    },
    "SUMMONING": {
        "color": "magenta",
        "keywords": [
            r"\bsummon\b", r"\bconjure\b", r"\bportal\b", r"\bteleport\b",
            r"\bcreate\b", r"\bmanifest\b", r"\bcall\b", r"\bdimension\b",
        ],
    },
    "DIVINATION": {
        "color": "cyan",
        "keywords": [
            r"\bdetect\b", r"\breveal\b", r"\bsee\b", r"\bsense\b", r"\bvision\b",
            r"\bperceive\b", r"\bidentify\b", r"\blocate\b", r"\bfind\b",
            r"\binvisible\b", r"\binvisibility\b", r"\bhidden\b", r"\bmagic\b",
        ],
    },
    "GENERIC": {
        "color": "blue",
        "keywords": [],  # No auto-coloring for generic
    },
}

# Damage type to color (fallback if no sphere)
DAMAGE_COLORS = {
    "FIRE": "b:red",
    "COLD": "b:cyan",
    "SHOCK": "b:yellow",
    "ACID": "green",
    "POISON": "green",
    "HEAL": "healing",
    "NECROTIC": "magenta",
    "RADIANT": "b:yellow",
    "HOLY": "b:yellow",
    "UNHOLY": "magenta",
    "MENTAL": "b:magenta",
}


def colorize_keywords(text: str, color: str, keywords: List[str]) -> str:
    """Apply color tags to keywords in text."""
    if not keywords:
        return text

    # Find all matches across all keywords
    all_matches = []
    for keyword in keywords:
        pattern = re.compile(keyword, re.IGNORECASE)
        for match in pattern.finditer(text):
            all_matches.append((match.start(), match.end(), match.group(0)))

    if not all_matches:
        return text

    # Sort by position (start) and remove overlapping matches
    all_matches.sort(key=lambda x: x[0])
    non_overlapping = []
    last_end = -1
    for start, end, word in all_matches:
        if start >= last_end:
            non_overlapping.append((start, end, word))
            last_end = end

    # Insert color tags from end to start (so positions don't shift)
    result = text
    for start, end, word in reversed(non_overlapping):
        result = result[:start] + f"<{color}>{word}</>" + result[end:]

    return result


def add_colors_to_description(
    description: str,
    sphere: str = None,
    damage_type: str = None,
) -> str:
    """Add sphere-based colors to a spell description."""
    if not description:
        return description

    # Skip if already has color tags
    if "<" in description and ">" in description:
        return description

    # Get color config based on sphere
    if sphere and sphere in SPHERE_COLORS:
        config = SPHERE_COLORS[sphere]
        return colorize_keywords(description, config["color"], config["keywords"])

    # Fallback to damage type
    if damage_type and damage_type in DAMAGE_COLORS:
        # Just use the color for the whole description's key terms
        color = DAMAGE_COLORS[damage_type]
        # Find matching keywords from any sphere with this damage type
        for sphere_name, config in SPHERE_COLORS.items():
            if sphere_name in ["FIRE", "COLD", "WATER", "AIR", "EARTH", "HEALING", "DEATH"]:
                if damage_type == sphere_name or (
                    damage_type == "SHOCK" and sphere_name == "AIR"
                ):
                    return colorize_keywords(description, color, config["keywords"])

    return description


def process_abilities(abilities_path: Path, dry_run: bool = False) -> Dict[str, int]:
    """Add colors to spell descriptions in abilities.json."""
    stats = {
        "total": 0,
        "spells": 0,
        "colorized": 0,
        "already_colored": 0,
        "no_sphere": 0,
    }

    with open(abilities_path) as f:
        abilities = json.load(f)

    for ability in abilities:
        stats["total"] += 1

        if ability.get("abilityType") != "SPELL":
            continue

        stats["spells"] += 1

        description = ability.get("description", "")
        sphere = ability.get("sphere")
        damage_type = ability.get("damageType")

        if not description:
            continue

        if "<" in description and ">" in description:
            stats["already_colored"] += 1
            continue

        if not sphere and not damage_type:
            stats["no_sphere"] += 1
            continue

        new_description = add_colors_to_description(description, sphere, damage_type)

        if new_description != description:
            ability["description"] = new_description
            stats["colorized"] += 1
            if dry_run:
                print(f"  {ability['name']}: {new_description[:80]}...")

    if not dry_run:
        with open(abilities_path, "w") as f:
            json.dump(abilities, f, indent=2)
        print(f"Saved to {abilities_path}")

    return stats


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Add sphere-based colors to spell descriptions")
    parser.add_argument(
        "--abilities",
        type=Path,
        default=Path(__file__).parent.parent / "data" / "abilities.json",
        help="Path to abilities.json",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would change without modifying files",
    )

    args = parser.parse_args()

    print("=" * 60)
    print("Adding Sphere-Based Colors to Spell Descriptions")
    print("=" * 60)

    if args.dry_run:
        print("\n*** DRY RUN - No files will be modified ***\n")

    stats = process_abilities(args.abilities, args.dry_run)

    print("\n" + "=" * 60)
    print("Summary")
    print("=" * 60)
    print(f"  Total abilities:   {stats['total']}")
    print(f"  Spells:            {stats['spells']}")
    print(f"  Colorized:         {stats['colorized']}")
    print(f"  Already colored:   {stats['already_colored']}")
    print(f"  No sphere/damage:  {stats['no_sphere']}")


if __name__ == "__main__":
    main()
