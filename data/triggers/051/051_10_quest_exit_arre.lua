-- Trigger: quest_exit_arre
-- Zone: 51, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5110

-- Converted from DG Script #5110: quest_exit_arre
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: exit exit?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "exit") or string.find(string.lower(speech), "exit?")) then
    return true  -- No matching keywords
end
wait(2)
self:command("sigh")
self:say("Again, my time has been wasted.  Very well, leave.")
actor:send(tostring(self.name) .. " waves her arms, sending you out of her chamber.")
self.room:send_except(actor, tostring(self.name) .. " sweeps her arms through the air, sending " .. tostring(actor.name) .. " away.")
actor:teleport(get_room(580, 1))
actor:send("You blink and find yourself back on the pebbled path!")
-- actor looks around