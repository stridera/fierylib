-- Trigger: test-random
-- Zone: 30, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3026

-- Converted from DG Script #3026: test-random
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: random
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "random")) then
    return true  -- No matching keywords
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
local mob = self:get_mexists("3055")
local obj = self:get_oexists("1127")
actor:send("There are " .. tostring(mob) .. " Druidic guards of 3055 in the game.")
actor:send("There are " .. tostring(obj) .. " iron-banded girth's in the game.")