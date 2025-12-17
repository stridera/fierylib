"""Export effects and abilities from database to JSON files."""

import asyncio
import json
from pathlib import Path
from prisma import Prisma


async def export_effects(prisma: Prisma, output_path: Path):
    """Export all effects to JSON."""
    effects = await prisma.effect.find_many(order={"name": "asc"})

    effects_data = []
    for e in effects:
        effect_dict = {
            "name": e.name,
            "effectType": e.effectType,
            "description": e.description,
            "tags": e.tags or [],
        }
        if e.defaultParams:
            effect_dict["defaultParams"] = json.loads(e.defaultParams) if isinstance(e.defaultParams, str) else e.defaultParams
        if e.paramSchema:
            effect_dict["paramSchema"] = json.loads(e.paramSchema) if isinstance(e.paramSchema, str) else e.paramSchema
        effects_data.append(effect_dict)

    with open(output_path, "w") as f:
        json.dump(effects_data, f, indent=2)

    print(f"Exported {len(effects_data)} effects to {output_path}")
    return effects_data


async def export_abilities(prisma: Prisma, output_path: Path):
    """Export all abilities with their effects to JSON."""
    abilities = await prisma.ability.find_many(
        include={
            "school": True,
            "effects": {
                "include": {"effect": True},
                "order_by": {"order": "asc"}
            },
            "targeting": True,
            "savingThrows": True,
            "messages": True,
        },
        order={"name": "asc"}
    )

    abilities_data = []
    for a in abilities:
        ability_dict = {
            "gameId": a.gameId,
            "name": a.name,
            "plainName": a.plainName,
            "abilityType": a.abilityType,
            "description": a.description,
            "minPosition": a.minPosition,
            "violent": a.violent,
            "castTimeRounds": a.castTimeRounds,
            "cooldownMs": a.cooldownMs,
            "inCombatOnly": a.inCombatOnly,
            "isArea": a.isArea,
        }

        # Optional fields
        if a.school:
            ability_dict["school"] = a.school.name
        if a.notes:
            ability_dict["notes"] = a.notes
        if a.tags:
            ability_dict["tags"] = a.tags
        if a.luaScript:
            ability_dict["luaScript"] = a.luaScript

        # Effects with their parameters
        if a.effects:
            ability_dict["effects"] = []
            for ae in a.effects:
                effect_link = {
                    "effect": ae.effect.name,
                    "order": ae.order,
                }
                if ae.overrideParams:
                    params = json.loads(ae.overrideParams) if isinstance(ae.overrideParams, str) else ae.overrideParams
                    effect_link["params"] = params
                if ae.trigger:
                    effect_link["trigger"] = ae.trigger
                if ae.chancePct != 100:
                    effect_link["chancePct"] = ae.chancePct
                if ae.condition:
                    effect_link["condition"] = ae.condition
                ability_dict["effects"].append(effect_link)

        # Targeting
        if a.targeting:
            t = a.targeting
            ability_dict["targeting"] = {
                "validTargets": t.validTargets,
                "scope": t.scope,
                "range": t.range,
            }
            if t.maxTargets and t.maxTargets != 1:
                ability_dict["targeting"]["maxTargets"] = t.maxTargets
            if t.scopePattern:
                ability_dict["targeting"]["scopePattern"] = t.scopePattern
            if t.requireLos:
                ability_dict["targeting"]["requireLos"] = t.requireLos

        # Saving throws
        if a.savingThrows:
            ability_dict["savingThrows"] = [
                {
                    "saveType": st.saveType,
                    "dcFormula": st.dcFormula,
                    "onSaveAction": json.loads(st.onSaveAction) if isinstance(st.onSaveAction, str) else st.onSaveAction,
                }
                for st in a.savingThrows
            ]

        # Messages
        if a.messages:
            m = a.messages
            msgs = {}
            if m.startToCaster:
                msgs["startToCaster"] = m.startToCaster
            if m.startToVictim:
                msgs["startToVictim"] = m.startToVictim
            if m.startToRoom:
                msgs["startToRoom"] = m.startToRoom
            if m.successToCaster:
                msgs["successToCaster"] = m.successToCaster
            if m.successToVictim:
                msgs["successToVictim"] = m.successToVictim
            if m.successToRoom:
                msgs["successToRoom"] = m.successToRoom
            if m.failToCaster:
                msgs["failToCaster"] = m.failToCaster
            if m.failToVictim:
                msgs["failToVictim"] = m.failToVictim
            if m.failToRoom:
                msgs["failToRoom"] = m.failToRoom
            if m.wearoffToTarget:
                msgs["wearoffToTarget"] = m.wearoffToTarget
            if msgs:
                ability_dict["messages"] = msgs

        abilities_data.append(ability_dict)

    with open(output_path, "w") as f:
        json.dump(abilities_data, f, indent=2)

    print(f"Exported {len(abilities_data)} abilities to {output_path}")
    return abilities_data


async def main():
    data_dir = Path(__file__).parent.parent / "data"
    data_dir.mkdir(exist_ok=True)

    prisma = Prisma()
    await prisma.connect()

    try:
        await export_effects(prisma, data_dir / "effects.json")
        await export_abilities(prisma, data_dir / "abilities.json")
        print("\nExport complete!")
    finally:
        await prisma.disconnect()


if __name__ == "__main__":
    asyncio.run(main())
