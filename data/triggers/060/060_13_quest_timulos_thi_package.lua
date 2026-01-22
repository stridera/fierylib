-- Trigger: quest_timulos_thi_package
-- Zone: 60, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6013

-- Converted from DG Script #6013: quest_timulos_thi_package
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: package? package
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "package?") or string.find(string.lower(speech), "package")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" and actor:get_quest_stage("merc_ass_thi_subclass") == 1 then
    actor.name:advance_quest("merc_ass_thi_subclass")
    actor:send(tostring(self.name) .. " says, 'Yes a package.'")
    self:command("fume")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Some time ago it was sent and picked up by someone who should not have.'")
    self:command("grumble")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Bloody <b:cyan>farmers</>.'")
end