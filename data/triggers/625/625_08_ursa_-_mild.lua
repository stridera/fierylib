-- Trigger: Ursa -> mild
-- Zone: 625, ID: 8
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #62508

-- Converted from DG Script #62508: Ursa -> mild
-- Original: MOB trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
-- This needs to change him back to merchant if out of a fight for some time
local here = self.room
local look = get.people[here.vnum]
if look == 1 then
    self:emote("calms down, and reverts to his normal self.")
    self.room:spawn_mobile(625, 6)
    world.destroy(self.room:find_actor("self"))
else
    return _return_value
end