-- Trigger: rock_demon_fight
-- Zone: 520, ID: 15
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #52015

-- Converted from DG Script #52015: rock_demon_fight
-- Original: MOB trigger, flags: FIGHT, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
wait(1)
self:emote("starts to glow slightly and his eyes burn hotly.")
self:say("uruk chachronu vuur")
self:emote("gestures upwards with his hands.")
run_room_trigger(52000)