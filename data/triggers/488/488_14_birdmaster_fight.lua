-- Trigger: birdmaster fight
-- Zone: 488, ID: 14
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48814

-- Converted from DG Script #48814: birdmaster fight
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
if world.count_mobiles("48815") < 6 then
    wait(1)
    self:emote("holds a bird whistle to his lips and lets out a loud whistle!")
    wait(1)
    self.room:spawn_mobile(488, 15)
    self.room:find_actor("cavern-hawk"):emote("swoops in to the aid of " .. tostring(self.name) .. "!")
    self.room:find_actor("cavern-hawk"):command("hit %actor.name%")
end