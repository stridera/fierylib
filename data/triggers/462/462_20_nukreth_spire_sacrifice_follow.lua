-- Trigger: Nukreth Spire sacrifice follow
-- Zone: 462, ID: 20
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #46220

-- Converted from DG Script #46220: Nukreth Spire sacrifice follow
-- Original: MOB trigger, flags: SPEECH, probability: 0%
-- (legacy 0% probability was a no-op gate; speech keyword match is the gate.)

-- Speech keywords: follow me
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "follow") or string.find(speech_lower, "me")) then
    return true  -- No matching keywords
end
wait(2)
if world.count_mobiles(462, 1) == 0 and world.count_mobiles(462, 24) == 0 then
    if not globals.leader then
        self:follow(actor)
        self:say("Lead on.")
        globals.leader = actor.name
    else
        return true
    end
else
    self:say("Save us from these beasts first!")
end