-- Trigger: waterform_cup_replacement
-- Zone: 28, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2810

-- Converted from DG Script #2810: waterform_cup_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need a new cup
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "cup")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("waterform") > 3 and actor:get_quest_var("waterform:new") == 0 then
    actor.name:set_quest_var("waterform", "new", "yes")
    self:say("Oh no, you lost the cup??")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Well, I can make a new one, but you'll need to find the")
    self.room:send("</>base materials again.'")
    wait(2)
    self:say("Go find another acceptable dragon bone.")
end