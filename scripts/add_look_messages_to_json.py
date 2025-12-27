#!/usr/bin/env python3
"""Add lookMessage values to abilities.json for visual spell effects."""

import json
from pathlib import Path

# Map of ability plainName to lookMessage
# Placeholders: {pronoun.possessive} = His/Her/Their, {pronoun.subjective} = He/She/They
LOOK_MESSAGES = {
    # Protection Auras
    "SANCTUARY": "{pronoun.subjective} glows with a bright white aura.",
    "FIRESHIELD": "{pronoun.subjective} is surrounded by a shield of burning flames.",
    "COLDSHIELD": "{pronoun.subjective} is surrounded by a shield of bitter frost.",
    "SOULSHIELD": "{pronoun.subjective} is surrounded by an ethereal protective barrier.",
    "SPHERE_PROTECTION": "{pronoun.subjective} is enclosed in a shimmering protective sphere.",
    "PROT_FROM_EVIL": "{pronoun.subjective} is surrounded by a faint protective aura.",
    "PROT_FROM_GOOD": "{pronoun.subjective} is surrounded by a faint dark aura.",

    # Visual Alterations
    "BLUR": "{pronoun.possessive} image appears blurred and difficult to focus on.",
    "INVISIBLE": "{pronoun.subjective} appears semi-transparent and shimmering.",
    "MASS_INVIS": "{pronoun.subjective} appears semi-transparent and shimmering.",
    "VAPORFORM": "{pronoun.possessive} body appears as swirling mist.",
    "SHADOW": "{pronoun.subjective} is cloaked in swirling shadows.",
    "DARKNESS": "{pronoun.subjective} is shrouded in an aura of magical darkness.",

    # Physical Transformations
    "STONE_SKIN": "{pronoun.possessive} body appears to be made of stone.",
    "BARKSKIN": "{pronoun.possessive} skin is thick, brown and wrinkley like bark.",
    "ARMOR_OF_GAIA": "{pronoun.subjective} is encased in armor of living earth and stone.",
    "BONE_ARMOR": "{pronoun.subjective} is encased in a grotesque armor of bones.",
    "ICE_ARMOR": "{pronoun.subjective} is encased in glistening armor of solid ice.",

    # Movement/Position
    "FLY": "{pronoun.subjective} is hovering in the air.",
    "HASTE": "{pronoun.subjective} is moving with unnatural speed.",
    "FEATHER_FALL": "{pronoun.subjective} appears to be light as a feather.",

    # Divine/Demonic
    "DIVINE_ESSENCE": "{pronoun.subjective} radiates with pure divine essence.",
    "DARK_PRESENCE": "{pronoun.subjective} exudes an aura of dark malevolence.",
    "DEMONIC_ASPECT": "{pronoun.subjective} has taken on a terrifying demonic appearance.",
    "DEMONIC_MUTATION": "{pronoun.possessive} body writhes with demonic mutations.",
    "WINGS_OF_HEAVEN": "{pronoun.subjective} has glowing angelic wings sprouting from {pronoun.possessive} back.",
    "WINGS_OF_HELL": "{pronoun.subjective} has dark, leathery demonic wings sprouting from {pronoun.possessive} back.",

    # Debuffs (visible)
    "POISON": "{pronoun.subjective} looks extremely sick and has a greenish pallor.",
    "DISEASE": "{pronoun.subjective} looks terribly ill and diseased.",
    "FEAR": "{pronoun.subjective} is cowering in abject terror.",
    "TERROR": "{pronoun.subjective} is cowering in abject terror.",
    "CONFUSION": "{pronoun.subjective} looks dazed and confused.",
    "SLEEP": "{pronoun.subjective} is in a deep magical slumber.",
    "SILENCE": "A sphere of silence surrounds {pronoun.subjective}.",
    "WEB": "{pronoun.subjective} is covered in sticky webs.",
    "CHARM": "{pronoun.possessive} eyes have a glazed, vacant look.",

    # Combat States
    "BERSERK": "{pronoun.possessive} eyes are wild with bloodlust and rage.",
    "ON_FIRE": "{pronoun.subjective} is engulfed in flames!",
    "FLAME_BLADE": "{pronoun.possessive} weapon burns with magical flames.",

    # Blessings
    "BLESS": "{pronoun.subjective} looks blessed and protected.",
    "EARTH_BLESSING": "{pronoun.subjective} is surrounded by a faint earthy glow.",
    "CIRCLE_OF_LIGHT": "{pronoun.subjective} is bathed in a brilliant circle of light.",
    "ENLIGHTENMENT": "{pronoun.possessive} eyes glow with inner wisdom.",
    "DOOM": "{pronoun.subjective} glows with a divine, protective light.",

    # Perception
    "INFRAVISION": "{pronoun.possessive} eyes glow with a faint red hue.",
}


def main():
    data_path = Path(__file__).parent.parent / "data" / "abilities.json"

    if not data_path.exists():
        print(f"Error: {data_path} not found")
        return 1

    print(f"Reading {data_path}...")
    with open(data_path) as f:
        abilities = json.load(f)

    updated = 0
    for ability in abilities:
        plain_name = ability.get("plainName", "")
        if plain_name in LOOK_MESSAGES:
            if "messages" not in ability:
                ability["messages"] = {}

            # Only add if not already present
            if not ability["messages"].get("lookMessage"):
                ability["messages"]["lookMessage"] = LOOK_MESSAGES[plain_name]
                print(f"  Added lookMessage for: {ability['name']}")
                updated += 1
            else:
                print(f"  Skipped (already has lookMessage): {ability['name']}")

    print(f"\nWriting {data_path}...")
    with open(data_path, "w") as f:
        json.dump(abilities, f, indent=2)

    print(f"\nUpdated {updated} abilities with lookMessage values")
    return 0


if __name__ == "__main__":
    exit(main())
