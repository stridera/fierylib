-- Trigger: pyromancer_subclass_quest_emmath_speech1
-- Zone: 52, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5203
--
-- Hook for first-contact "flame/life" speech. Pyromancers get brushed off,
-- eligible Sorcerers get the recruitment pitch (with race/level gating),
-- everyone else gets a polite refusal.

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"flame?", "flames?", "life?", "flame", "flames", "life"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

if string.find(actor.class, "pyromancer") then
    wait(2)
    self:command("chuckle")
    actor:send(tostring(self.name) .. " says, 'I have nothing more to teach you, young one.'")
elseif not actor:get_quest_stage("pyromancer_subclass") then
    if string.find(actor.class, "sorcerer") then
        if actor.race == "dragonborn_frost" or actor.race == "arborean" then
            actor:send("<red>Your race may not subclass to pyromancer.</>")
            return true
        end
        wait(2)
        if actor.level >= 10 and actor.level <= 45 then
            self:command("nod " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Do you wish to become one with the flame, becoming a mage of fire?'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Not yet, for you are still an initiate.  Come back when you have gained more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
        end
    else
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you learn the ways of the flame.'")
    end
end