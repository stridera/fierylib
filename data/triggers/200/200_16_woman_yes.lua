-- Trigger: woman_yes
-- Zone: 200, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20016

-- Converted from DG Script #20016: woman_yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "nods", "ok"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("smile " .. tostring(actor.name))
wait(0.1)
self:say("There is a guard to the north that is blocking the way to my escape.")
self:say("I need you to go kill him and bring back his axe,")
self:say("so i have proof you have killed him.")
self:say("Go now.")
actor:move("n")
self:command("vis")