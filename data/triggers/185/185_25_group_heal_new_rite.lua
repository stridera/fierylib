-- Trigger: group_heal_new_rite
-- Zone: 185, ID: 25
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #18525

-- Converted from DG Script #18525: group_heal_new_rite
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I lost the Rite
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "lost") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "rite")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("group_heal") == 5 or elseif actor:get_quest_stage("group_heal") == 6 then
    self:say("You need to be more careful!")
    wait(1)
    self:say("Fortunately I made a copy of the original.")
    self.room:spawn_object(185, 14)
    self:command("give rite-heroes-feast " .. tostring(actor))
end