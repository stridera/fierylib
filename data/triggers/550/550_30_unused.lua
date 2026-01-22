-- Trigger: **UNUSED**
-- Zone: 550, ID: 30
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #55030

-- Converted from DG Script #55030: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: enter
if not (cmd == "enter") then
    return true  -- Not our command
end
-- 
-- Test trigger to see if checks can be done
-- before a player can enter a portal.
-- 
if actor:get_has_completed("doom_entrance") == "true" then
    self.room:send_except(actor, "Dude like disappears and stuff.")
    actor:send("You step through the portal.")
    actor:teleport(get_room(12, 10))
else
    self.room:send_except(actor, "Dude tries to enter... NOT.")
    actor:send("Hows about you complete the quest first?")
end