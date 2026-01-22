-- Trigger: reload_helpers
-- Zone: 533, ID: 3
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #53303

-- Converted from DG Script #53303: reload_helpers
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
wait(1)
local value = random(1, 10)
if value < 2 then
    self:emote("roars in pain and tries to locate more children.")
    wait(1)
    if world.count_mobiles("53301") < 6 then
        self.room:spawn_mobile(533, 1)
        self.room:find_actor("baby-dragon"):emote("scampers in and attacks!")
        self.room:find_actor("baby-dragon"):command("kill %actor.name%")
    end
end