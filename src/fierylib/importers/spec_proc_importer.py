"""
Spec Proc Importer - Applies special procedure flags and scripts to mobs

This maps the legacy spec_assign.cpp assignments to:
1. MobFlags for command-handler behaviors (RECEPTIONIST, POSTMASTER, BANKER)
2. Scripts for behavioral spec_procs (guild_guard, janitor, cityguard)

The mappings are extracted from fierymud/legacy/src/spec_assign.cpp
"""

from typing import Dict, List, Optional, Tuple

from fierylib.converters import EntityResolver


# Command-handler spec_procs -> MobFlag mappings
# These indicate the mob responds to specific player commands
SPEC_PROC_FLAGS: Dict[str, List[int]] = {
    "RECEPTIONIST": [
        # Mielikki
        3005,
        # Anduin
        6227, 6017,
        # Ickle
        10054,
        # Ogakh
        30001,
        # Nymrill
        49500,
        # Others
        1402, 58701, 1,
    ],
    "POSTMASTER": [
        # Mielikki
        3095,
        # Anduin
        6171,
        # Ickle
        10055,
        # Ogakh
        30043,
    ],
    # Note: BANKER is typically on objects, not mobs in this codebase
}

# Behavioral spec_procs -> Script template mappings
# These behaviors should be implemented as Lua scripts
BEHAVIORAL_SPEC_PROCS: Dict[str, Dict] = {
    "guild_guard": {
        "mobs": [
            # Anduin
            6114,  # mercenary
            6007,  # diabolist
            6008,  # antipal
            6040,  # assassin
            6041,  # thief
            6060,  # bard
            6175,  # druid guard
            6216,  # priest/cleric guard
            6217,  # paladin
            6219,  # necro
            6201,  # pyro
            6202,  # cryo
            6206,  # sorceror
            6210,  # illusionist
            55704,  # berserker
            # Ickle
            10010,  # cleric
            10011,  # warrior
            10012,  # sorceror
            10013,  # mercenary
            10200,  # berserker
            # Mielikki
            3014,  # illusionist
            3024,  # sorc pyro cryo
            3054,  # cleric druid priest
            3026,  # rogue thief assa bard merc
            3027,  # warrior
            3549,  # ranger
            5300,  # paladin
            5302,  # monk
            16911,  # necro HH
            3201,  # berserker
            5304,  # bard
            # Ogakh
            30039, 30041, 30042, 30040,
            30046, 30047, 30048, 30049,
            30057, 30079, 30082,
        ],
        "script_name": "guild_guard",
        "trigger_type": "PREENTRY",  # Fires BEFORE player enters the room
        "script_template": """-- Guild Guard Script (PREENTRY trigger)
-- Blocks entry to guild hall unless player is the correct class
-- Trigger type: PREENTRY - fires when someone tries to enter this room

-- allowed_classes should be set in mob data, e.g. {"WARRIOR", "PALADIN"}
local allowed_classes = mob:get_data("allowed_classes") or {}
local player_class = actor:get_class()

-- Check if player's class is allowed
for _, class in ipairs(allowed_classes) do
    if player_class == class then
        return true  -- Allow entry
    end
end

-- Block entry
mob:say("The guild is closed to you, " .. actor:get_name() .. ".")
return false  -- Prevent movement
""",
    },
    "janitor": {
        "mobs": [
            # Mielikki
            3061, 3068,
            # Anduin
            6115,
        ],
        "script_name": "janitor",
        "script_template": """-- Janitor Script
-- Periodically picks up items from the ground and destroys them

on_tick = function()
    local items = room:get_items()
    for _, item in ipairs(items) do
        if item:can_take() and not item:is_permanent() then
            mob:emote("picks up " .. item:get_short_desc() .. " and disposes of it.")
            item:destroy()
            return  -- One item per tick
        end
    end
end
""",
    },
    "cityguard": {
        "mobs": [
            # Anduin
            6011, 6012, 6018, 6101, 6102, 6154, 6106, 6104, 6200, 6203, 6204,
        ],
        "script_name": "cityguard",
        "script_template": """-- City Guard Script
-- Responds to calls for help and attacks criminals

on_shout = function(shouter, message)
    if string.find(message:lower(), "help") then
        mob:emote("rushes to help!")
        mob:hunt(shouter)
    end
end

on_see_crime = function(criminal, crime_type)
    mob:say("Stop right there, criminal scum!")
    mob:attack(criminal)
end
""",
    },
    "guild": {
        "mobs": [
            # Anduin
            6006, 6007, 6231, 6032, 6080, 6020, 6061, 6113, 6176, 55703,
            6220, 6221, 6222, 6218, 6223, 6211,
            # Ickle
            10000, 10001, 10002, 10003, 10201,
            # Mielikki
            3018, 3020, 3021, 3022, 3023, 3053, 3490, 3491, 3492,
            3504, 5301, 5303, 16910, 3200, 5305,
            # Ogakh
            30019, 30016, 30018, 30017, 30058, 30059, 30060, 30061, 30062,
            30078, 30081,
            # Nymrill
            49514, 49522, 49525,
        ],
        "script_name": "guildmaster",
        "script_template": """-- Guildmaster Script
-- Trains players in skills and spells for their class

on_command_practice = function(player, skill_name)
    if not mob:can_train(player) then
        mob:say("I cannot teach you anything, " .. player:get_name() .. ".")
        return false
    end

    if skill_name then
        return mob:train_skill(player, skill_name)
    else
        return mob:list_trainable_skills(player)
    end
end
""",
    },
}


class SpecProcImporter:
    """Applies special procedure flags and scripts to mobs"""

    def __init__(self, prisma_client):
        self.prisma = prisma_client
        self.resolver = EntityResolver(prisma_client)

    async def apply_spec_proc_flags(self, dry_run: bool = False) -> dict:
        """
        Apply command-handler flags (RECEPTIONIST, POSTMASTER) to mobs
        based on spec_assign.cpp mappings.

        Args:
            dry_run: If True, report what would be done without making changes

        Returns:
            Dict with results
        """
        results = {
            "success": True,
            "flags_applied": 0,
            "mobs_not_found": [],
            "details": [],
        }

        for flag_name, mob_vnums in SPEC_PROC_FLAGS.items():
            for vnum in mob_vnums:
                # Use EntityResolver to find mob by vnum with database verification
                context_zone = vnum // 100 if vnum >= 100 else 0
                mob_result = await self.resolver.resolve_mob(vnum, context_zone=context_zone)

                if not mob_result:
                    results["mobs_not_found"].append(vnum)
                    continue

                zone_id, mob_id = mob_result.zone_id, mob_result.id

                try:
                    # Get full mob record for flag update
                    mob = await self.prisma.mobs.find_unique(
                        where={
                            "zoneId_id": {
                                "zoneId": zone_id,
                                "id": mob_id,
                            }
                        }
                    )

                    # Check if flag already applied
                    if flag_name in mob.mobFlags:
                        results["details"].append({
                            "vnum": vnum,
                            "flag": flag_name,
                            "action": "already_has_flag",
                        })
                        continue

                    if dry_run:
                        results["flags_applied"] += 1
                        results["details"].append({
                            "vnum": vnum,
                            "mob_name": mob.name,
                            "flag": flag_name,
                            "action": "would_apply",
                        })
                    else:
                        # Add flag to mob
                        new_flags = list(mob.mobFlags) + [flag_name]
                        await self.prisma.mobs.update(
                            where={
                                "zoneId_id": {
                                    "zoneId": zone_id,
                                    "id": mob_id,
                                }
                            },
                            data={"mobFlags": new_flags}
                        )
                        results["flags_applied"] += 1
                        results["details"].append({
                            "vnum": vnum,
                            "mob_name": mob.name,
                            "flag": flag_name,
                            "action": "applied",
                        })

                except Exception as e:
                    results["details"].append({
                        "vnum": vnum,
                        "flag": flag_name,
                        "action": "error",
                        "error": str(e),
                    })

        return results

    async def create_behavioral_scripts(self, dry_run: bool = False) -> dict:
        """
        Create Lua scripts for behavioral spec_procs and attach to mobs.

        Args:
            dry_run: If True, report what would be done without making changes

        Returns:
            Dict with results
        """
        results = {
            "success": True,
            "scripts_created": 0,
            "scripts_attached": 0,
            "mobs_not_found": [],
            "details": [],
        }

        for spec_name, spec_data in BEHAVIORAL_SPEC_PROCS.items():
            script_name = spec_data["script_name"]
            script_template = spec_data["script_template"]
            mob_vnums = spec_data["mobs"]

            # For now, just report what would be done
            # The actual script creation would need the trigger system
            results["details"].append({
                "spec_proc": spec_name,
                "script_name": script_name,
                "mob_count": len(mob_vnums),
                "action": "would_create" if dry_run else "template_ready",
            })

            for vnum in mob_vnums:
                # Use EntityResolver to find mob by vnum with database verification
                context_zone = vnum // 100 if vnum >= 100 else 0
                mob_result = await self.resolver.resolve_mob(vnum, context_zone=context_zone)

                if not mob_result:
                    results["mobs_not_found"].append(vnum)
                    continue

                # Mob exists, count it for script attachment
                results["scripts_attached"] += 1

        return results

    async def apply_all(self, dry_run: bool = False) -> dict:
        """
        Apply all spec_proc mappings (flags and scripts).

        Args:
            dry_run: If True, report what would be done without making changes

        Returns:
            Combined results
        """
        flag_results = await self.apply_spec_proc_flags(dry_run=dry_run)
        script_results = await self.create_behavioral_scripts(dry_run=dry_run)

        return {
            "success": flag_results["success"] and script_results["success"],
            "flags": flag_results,
            "scripts": script_results,
        }
