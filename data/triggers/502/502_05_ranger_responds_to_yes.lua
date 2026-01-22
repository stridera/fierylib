-- Trigger: Ranger responds to yes
-- Zone: 502, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #50205

-- Converted from DG Script #50205: Ranger responds to yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(6)
if world.count_mobiles("50209") < 1 then
    self:command("peer " .. tostring(actor.name))
else
    self:say("Well, a ghostly fellow ran by here just a moment ago.")
    run_room_trigger(50206)
end