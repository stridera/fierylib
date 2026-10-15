-- Trigger: quest_timulos_thi_package
-- Zone: 60, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6013

-- Converted from DG Script #6013: quest_timulos_thi_package
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"package?", "package"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" and actor:get_quest_stage("merc_ass_thi_subclass") == 1 then
    actor:advance_quest("merc_ass_thi_subclass")
    actor:send(tostring(self.name) .. " says, 'Yes a package.'")
    self:command("fume")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Some time ago it was sent and picked up by someone who should not have.'")
    self:command("grumble")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Bloody <b:cyan>farmers</>.'")
end