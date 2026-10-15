-- Trigger: hellfire_brimstone_patriarch_speech
-- Zone: 23, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2308

-- Converted from DG Script #2308: hellfire_brimstone_patriarch_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "diabolist") and actor.level > 56 and actor:get_quest_stage("hellfire_brimstone") == 0 then
    actor:start_quest("hellfire_brimstone")
    wait(0.2)
    self:command("grin")
    self.room:send(tostring(self.name) .. " says, 'Then first, you must prove your dedication to the dark")
    self.room:send("</>gods.'")
    wait(2)
    self:say("I need more meat to stoke the sacrificial bonfire!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Slaughter paladins at the Sacred Haven, bring back")
    self.room:send("</>their flesh, and <b:red>[drop]</> it on the fire.'")
    wait(4)
    self:say("Six pounds should keep the fire burning long enough.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you need guidance, ask me about your <b:white>[spell progress]</>.'")
end