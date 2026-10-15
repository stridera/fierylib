-- Trigger: ent_ruin
-- Zone: 200, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20005

-- Converted from DG Script #20005: ent_ruin
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I am an enemy of Ruin Wormheart (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]i am an enemy of ruin wormheart[%s%p]") then
    return true  -- Not the phrase
end
self:command("nod")
self:say("You may enter as an ally of the dark monks.")
self:command("unlock gate")
self:command("open gate")
self:command("bow")