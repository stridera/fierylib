-- Trigger: prior_see_abbot
-- Zone: 200, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20020

-- Converted from DG Script #20020: prior_see_abbot
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: i must see the abbot (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]i must see the abbot[%s%p]") then
    return true  -- Not the phrase
end
self:command("nod")
self:say("You may see him at once!")
self:command("unlock door w")
self:command("open door w")