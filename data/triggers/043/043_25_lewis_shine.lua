-- Trigger: lewis_shine
-- Zone: 43, ID: 25
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4325

-- Converted from DG Script #4325: lewis_shine
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("eyes himself in the mirror.")
wait(3)
self:say("Hello beautiful.")
self:emote("winks at his reflection.")
wait(4)
self:say("Look how I shine!")
self:emote("bats his eyelashes for you to better bask in his glory.")
wait(5)
self:emote("is quickly distracted by something else shiny in the room.")
wait(3)
self:say("Visigoths!  Ha!")
self:emote("swings an invisible sword around at unseen foes.")