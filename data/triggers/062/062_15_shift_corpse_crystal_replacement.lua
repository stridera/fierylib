-- Trigger: Shift_corpse_crystal_replacement
-- Zone: 62, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6215

-- Converted from DG Script #6215: Shift_corpse_crystal_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need a new crystal
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "crystal")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("shift_corpse") then
    self:say("I can assist.")
    wait(1)
    self:emote("opens a pitch black box.")
    wait(4)
    self:emote("takes a glowing black crystal from the box.")
    wait(1)
    self:say("Take this.")
    self.room:spawn_object(62, 28)
    self:command("give glowing-black-crystal " .. tostring(actor))
    wait(1)
    self:say("Be more careful this time.")
end