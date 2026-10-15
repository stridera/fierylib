-- Trigger: Gypsy_Prince_ask1
-- Zone: 584, ID: 14
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #58414

-- Converted from DG Script #58414: Gypsy_Prince_ask1
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"greeting", "hi", "hello", "quest"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("major_spell_quest") ~= 2 then
    return true
end

wait(0.1)
self:command("eye " .. tostring(actor.name))
wait(0.1)
actor:send(tostring(self.name) .. " says to you, 'Greetings, traveler what brings you to my camp?'")
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")