-- Trigger: mist_caster_rand_fog
-- Zone: 118, ID: 1
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
self.room:find_actor("mist"):set_attr("invis", 100)
wait(2)
spells.cast(self, "wall of fog")