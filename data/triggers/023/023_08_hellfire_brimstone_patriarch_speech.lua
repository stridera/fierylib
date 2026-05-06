-- Trigger: hellfire_brimstone_patriarch_speech
-- Zone: 23, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2308

-- Converted from DG Script #2308: hellfire_brimstone_patriarch_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Diabolist") and actor.level > 56 and actor:get_quest_stage("hellfire_brimstone") == 0 then
    actor:start_quest("hellfire_brimstone")
    wait(2)
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