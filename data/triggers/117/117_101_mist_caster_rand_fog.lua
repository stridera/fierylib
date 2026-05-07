-- Trigger: mist_caster_rand_fog
-- Zone: 117, ID: 101
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #11801

-- Converted from DG Script #11801: mist_caster_rand_fog
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
-- TODO: actor:set_attr is not yet bound in lua_actor.cpp; the original DG
-- script set the mist mob's invis level to 100 before casting. Re-enable once
-- the binding (or an equivalent `set_invis_level`) is available.
local mist = self.room:find_actor("mist")
if mist then
    -- mist:set_attr("invis", 100)
end
wait(2)
spells.cast(self, "wall of fog")