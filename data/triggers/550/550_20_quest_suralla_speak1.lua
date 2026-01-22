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
if string.find(actor.class, "Sorcerer") then
    -- switch on actor.race
    if actor.level >= 10 and actor.level <= 45 then
        if actor.race == "dragonborn_fire" or actor.race == "arborean" then
            actor:send("<red>Your race cannot subclass to cryomancer.</>")
        end
        return _return_value
    else
        wait(2)
        if actor.level >= 10 and actor.level <= 45 then
            actor:send(tostring(self.name) .. " says, 'Do you wish to become a mage mastering the elements of ice and water and wind?'")
        elseif string.find(actor.class, "Sorcerer") and actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Come back to me once you've gained more experience.'")
        elseif string.find(actor.class, "Sorcerer") and actor.level > 45 then
            actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
        end
    end
end