-- Trigger: Black_Rose_Spawn_Pluck
-- Zone: 32, ID: 99
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3299

-- Converted from DG Script #3299: Black_Rose_Spawn_Pluck
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: Pluck
if not (cmd == "Pluck") then
    return true  -- Not our command
end
actor:send("You bend over and carefully pluck the &9<blue>black</> rose from between the two hearts.")
-- *some command to directly load 3298 to player inventory**
self.room:send_except(actor, tostring(actor.name) .. " bends over and carefully plucks the &9<blue>black</> rose from between the two hearts.")
wait(1)
self.room:send("Another identical &9<blue>black</> rose magically grows up in the same spot.")