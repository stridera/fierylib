-- Trigger: oracle-sun-extra-key
-- Zone: 484, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48426

-- Converted from DG Script #48426: oracle-sun-extra-key
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: key
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "key")) then
    return true  -- No matching keywords
end
if actor:get_has_completed("doom_entrance") then
    self.room:spawn_object(484, 21)
    self:command("give key " .. tostring(actor.name))
    self:say("Of course, " .. tostring(actor.name) .. ".")
    wait(1)
    self:say("Good luck against Lokari!")
end