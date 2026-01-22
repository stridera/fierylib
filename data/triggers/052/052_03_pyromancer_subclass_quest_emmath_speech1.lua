-- Trigger: pyromancer_subclass_quest_emmath_speech1
-- Zone: 52, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #5203

-- Converted from DG Script #5203: pyromancer_subclass_quest_emmath_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: flame? flames? life? flame flames life
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "flame?") or string.find(string.lower(speech), "flames?") or string.find(string.lower(speech), "life?") or string.find(string.lower(speech), "flame") or string.find(string.lower(speech), "flames") or string.find(string.lower(speech), "life")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Pyromancer") then
    wait(2)
    self:command("chuckle")
    actor:send(tostring(self.name) .. " says, 'I have nothing more to teach you, young one.'")
elseif not actor:get_quest_stage("pyromancer_subclass") then
    if string.find(actor.class, "Sorcerer") then
        -- switch on actor.race
        if actor.level >= 10 and actor.level <= 45 then
            if actor.race == "dragonborn_frost" or actor.race == "arborean" then
                actor:send("<red>Your race may not subclass to pyromancer.</>")
                return _return_value
            end
        else
            wait(2)
            if actor.level >= 10 and actor.level <= 45 then
                self:command("nod " .. tostring(actor.name))
                actor:send(tostring(self.name) .. " says, 'Do you wish to become one with the flame, becoming a mage of fire?'")
            elseif actor.level < 10 then
                actor:send(tostring(self.name) .. " says, 'Not yet, for you are still an initiate.  Come back when you have gained more experience.'")
            else
                actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
            end
        end
    else
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you learn the ways of the flame.'")
    end
end