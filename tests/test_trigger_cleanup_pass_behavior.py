"""Behaviour of the 2026-10-12 trigger cleanup pass under the Lua runtime mock (no DB).

Reuses the mock from test_trigger_vnum_scope_behavior. Category 1 scripts lost the converter's dead
`percent_chance(0)` guard; category 2 scripts had vnum ranges turned into zone_id checks.
"""

import pytest

from test_trigger_vnum_scope_behavior import LUA, Scenario, run_trigger, trigger_src

SCENARIOS = [
    # --- category 1: guard removed -------------------------------------------------------------
    # Speech phrase: the converter's OR of single words ("i", "a", ...) matched almost any sentence.
    Scenario(
        "030_90 answers the phrase 'I need a new notice'",
        "030/030_90_isilynor_new_contract.lua",
        """
        env.speech = "please, i need a new notice"
        env.self = entity("self", {name = "Isilynor"})
        env.actor = entity("actor", {level = 60}, {get_quest_stage = function() return 1 end})
        """,
        must=["actor.get_quest_stage"],
    ),
    Scenario(
        "030_90 ignores unrelated speech that contains the letter i",
        "030/030_90_isilynor_new_contract.lua",
        """
        env.speech = "i like the weather in this area"
        env.self = entity("self", {name = "Isilynor"})
        env.actor = entity("actor", {level = 60}, {get_quest_stage = function() return 1 end})
        """,
        must_not=["actor.get_quest_stage"],
    ),
    # Receive trigger, num_arg 0: runs for every item except the arg list (here 552:11 ... 2:140).
    Scenario(
        "030_35 thanks for an item that is not on the arg list",
        "030/030_35_magistrate_refuse.lua",
        """
        env.self = entity("self", {})
        env.actor = entity("actor", {})
        env.object = entity("object", {zone_id = 30, id = 1})
        """,
        must=["self.say:Thanks!"],
    ),
    Scenario(
        "030_35 leaves 555:77 to the specific receive trigger",
        "030/030_35_magistrate_refuse.lua",
        """
        env.self = entity("self", {})
        env.actor = entity("actor", {})
        env.object = entity("object", {zone_id = 555, id = 77})
        """,
        must_not=["self.say"],
    ),
    # World global: only runs through run_room_trigger, so the body must run when called.
    Scenario(
        "123_17 ritual effects run when called",
        "123/123_17_megalith_quest_ritual_effects1.lua",
        """
        env.zone = entity("zone")
        env.self = entity("self", {})
        env.actor = entity("actor", {})
        """,
        must=["The Keepers call out"],
    ),
    # --- category 2: vnum ranges over one zone ---------------------------------------------------
    Scenario(
        "489_26 sunchild sides with fellow doom mobs (zone 489 any id)",
        "489/489_26_sunchild_fight.lua",
        """
        env.get_room = function() return { at = function() print("AT") end } end
        env.self = entity("self", {room = room})
        env.actor = entity("actor", {zone_id = 489, id = 5})
        """,
        must=["AT"],
        must_not=["A Sunchild"],
    ),
    Scenario(
        "489_26 sunchild flares at an attacker from another zone with the same local id",
        "489/489_26_sunchild_fight.lua",
        """
        env.get_room = function() return { at = function() print("AT") end } end
        env.self = entity("self", {room = room})
        env.actor = entity("actor", {zone_id = 30, id = 5})
        """,
        must=["A Sunchild"],
        must_not=["AT"],
    ),
    Scenario(
        "484_103 doom spares zone 484 ids 100-199 and hits the rest",
        "484/484_103_mighty_druid_creeping_doom.lua",
        """
        env.Effect = { Sanctuary = 1, Stone = 2 }
        local function mk(label, z, i) return entity(label, {zone_id = z, id = i}, {has_effect = false}) end
        env.self = entity("self", {room = room}, {get_people = function()
          return { mk("inside", 484, 150), mk("elsewhere", 30, 150), mk("low", 484, 50) }
        end})
        """,
        must=["elsewhere.damage", "low.damage"],
        must_not=["inside.has_effect", "inside.damage"],
    ),
    Scenario(
        "030_53 exchange takes 553:10 for armor 55304 (id 4-83)",
        "030/030_53_armor_exchange_receive_exchange.lua",
        """
        env.self = entity("self", {name = "Exchanger", room = room})
        env.actor = entity("actor", {}, {get_quest_var = function() return 55304 end})
        env.object = entity("object", {zone_id = 553, id = 10, shortdesc = "a relic"})
        """,
        must=["Here you are my dear!"],
        must_not=["refuses"],
    ),
    Scenario(
        "030_53 exchange refuses 553:2 (below the 4-83 window) and 30:10 (other zone)",
        "030/030_53_armor_exchange_receive_exchange.lua",
        """
        env.self = entity("self", {name = "Exchanger", room = room})
        env.actor = entity("actor", {}, {get_quest_var = function() return 55304 end})
        env.object = entity("object", {zone_id = 30, id = 10, shortdesc = "a relic"})
        """,
        must=["refuses to perform the exchange"],
        must_not=["Here you are my dear!"],
    ),
    Scenario(
        "030_53 exchange refuses 553:2 (below the window)",
        "030/030_53_armor_exchange_receive_exchange.lua",
        """
        env.self = entity("self", {name = "Exchanger", room = room})
        env.actor = entity("actor", {}, {get_quest_var = function() return 55304 end})
        env.object = entity("object", {zone_id = 553, id = 2, shortdesc = "a relic"})
        """,
        must=["refuses to perform the exchange"],
        must_not=["Here you are my dear!"],
    ),
]


@pytest.mark.skipif(LUA is None, reason="no lua interpreter")
@pytest.mark.parametrize("sc", SCENARIOS, ids=lambda s: s.id)
def test_cleaned_trigger_takes_the_right_branch(sc):
    out = run_trigger(trigger_src(sc.trigger), sc.setup)
    assert "RESULT|" in out, out
    for needle in sc.must:
        assert needle in out, f"{needle!r} missing from:\n{out}"
    for needle in sc.must_not:
        assert needle not in out, f"{needle!r} unexpectedly present in:\n{out}"
