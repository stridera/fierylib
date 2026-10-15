-- Trigger: quest_suralla_speak1
-- Zone: 550, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55020

-- Converted from DG Script #55020: quest_suralla_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reason", "reason?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(string.lower(actor.class), "sorcerer") then
    if actor.level >= 10 and actor.level <= 45 then
        if actor.race == "dragonborn_fire" or actor.race == "arborean" then
            actor:send("<red>Your race cannot subclass to cryomancer.</>")
        else
            wait(0.2)
            actor:send(tostring(self.name) .. " says, 'Do you wish to become a mage mastering the elements of ice and water and wind?'")
        end
    elseif actor.level < 10 then
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Come back to me once you've gained more experience.'")
    elseif actor.level > 45 then
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
    end
end