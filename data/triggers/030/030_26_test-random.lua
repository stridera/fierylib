-- Trigger: test-random
-- Zone: 30, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3026

-- Converted from DG Script #3026: test-random
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"random"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- This is a test to generate a random number to be used
-- in many ways
self:say("My trigger commandlist is not complete!")
local random_number = random(1, 100)
if random_number >=51 then
    self:say("We're loading object.")
else
    self:say("We're not loading object.")
end
self:say(tostring(random_number))
local mob = self:get_mexists(30, 55)
local obj = self:get_oexists(11, 27)
actor:send("There are " .. tostring(mob) .. " Druidic guards of 3055 in the game.")
actor:send("There are " .. tostring(obj) .. " iron-banded girth's in the game.")