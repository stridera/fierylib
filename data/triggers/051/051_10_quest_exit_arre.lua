-- Trigger: quest_exit_arre
-- Zone: 51, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5110

-- Converted from DG Script #5110: quest_exit_arre
-- Original: MOB trigger, flags: SPEECH, probability: 100%
--
-- Player says "exit" -- Arre dismisses them back to the temple
-- entrance (580/1).

-- Speech keyword: exit
if not string.find(string.lower(speech), "exit") then
    return true  -- No matching keywords
end
wait(2)
self:command("sigh")
self:say("Again, my time has been wasted.  Very well, leave.")
actor:send(self.name .. " waves her arms, sending you out of her chamber.")
self.room:send_except(actor, self.name .. " sweeps her arms through the air, sending " .. actor.name .. " away.")
actor:teleport(get_room(580, 1))
actor:send("You blink and find yourself back on the pebbled path!")
actor:command("look")