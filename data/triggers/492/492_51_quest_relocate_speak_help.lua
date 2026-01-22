-- Trigger: quest_relocate_speak_help
-- Zone: 492, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49251

-- Converted from DG Script #49251: quest_relocate_speak_help
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help")) then
    return true  -- No matching keywords
end
if actor.level >= 65 then
    if actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" then
        wait(10)
        actor:send("A lost mage tells you, 'I used to know a spell, yes, quite the spell!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(10)
        actor:send("A lost mage tells you, 'But I do not have the materials I need...'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(5)
        self:command("ponder")
        actor:send("A lost mage tells you, 'Please, help me find the <b:cyan>items</>.'")
        self.room:send_except(actor, "A lost mage pleads with " .. tostring(actor.name) .. ".")
    end
end