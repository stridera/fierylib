-- Trigger: quest_eleweiss_ranger_druid_subclass_speak4
-- Zone: 163, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16305

-- Converted from DG Script #16305: quest_eleweiss_ranger_druid_subclass_speak4
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: something something? lost lost? it it? thing thing? what what?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "something") or string.find(string.lower(speech), "something?") or string.find(string.lower(speech), "lost") or string.find(string.lower(speech), "lost?") or string.find(string.lower(speech), "it") or string.find(string.lower(speech), "it?") or string.find(string.lower(speech), "thing") or string.find(string.lower(speech), "thing?") or string.find(string.lower(speech), "what") or string.find(string.lower(speech), "what?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("ran_dru_subclass") == 2 then
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'It seems I am becoming forgetful in my age.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Well, you see now, I lost the jewel of my heart.  If you are up to it, getting that and returning it to me will get you your reward.'")
    self:command("shrug")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'But for now, it is time for you to depart I think.'")
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'You have brought up painful memories for me to relive.'")
    actor.name:advance_quest("ran_dru_subclass")
end