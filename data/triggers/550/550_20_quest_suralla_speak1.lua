-- Trigger: quest_suralla_speak1
-- Zone: 550, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55020

-- Converted from DG Script #55020: quest_suralla_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: reason reason?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "reason") or string.find(string.lower(speech), "reason?")) then
    return true  -- No matching keywords
end
if string.find(string.lower(actor.class), "sorcerer") then
    if actor.level >= 10 and actor.level <= 45 then
        if actor.race == "dragonborn_fire" or actor.race == "arborean" then
            actor:send("<red>Your race cannot subclass to cryomancer.</>")
        else
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Do you wish to become a mage mastering the elements of ice and water and wind?'")
        end
    elseif actor.level < 10 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Come back to me once you've gained more experience.'")
    elseif actor.level > 45 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
    end
end