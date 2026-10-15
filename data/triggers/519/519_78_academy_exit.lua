-- Trigger: academy exit
-- Zone: 519, ID: 78
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51978

-- Converted from DG Script #51978: academy exit
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"exit", "exit?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    wait(0.2)
    self:command("nod " .. tostring(actor))
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  Come back any time.'")
    actor:teleport(get_room(30, 1))
    actor:send(tostring(self.name) .. " escorts you out of the Academy.")
    wait(0.2)
    get_room(30, 1):at(function()
        -- actor looks around
    end)
end