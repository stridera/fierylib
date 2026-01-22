-- Trigger: Nukreth Spire sacrifice follow
-- Zone: 462, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46220

-- Converted from DG Script #46220: Nukreth Spire sacrifice follow
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: follow me
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "follow") or string.find(string.lower(speech), "me")) then
    return true  -- No matching keywords
end
wait(2)
if world.count_mobiles("46201") == 0 and world.count_mobiles("46224") == 0 then
    if not leader then
        self:follow(actor)
        self:say("Lead on.")
        local leader = actor.name
        globals.leader = globals.leader or true
    else
        return _return_value
    end
else
    self:say("Save us from these beasts first!")
end