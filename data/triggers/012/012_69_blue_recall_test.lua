-- Trigger: blue_recall_test
-- Zone: 12, ID: 69
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1269

-- Converted from DG Script #1269: blue_recall_test
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: recite
if not (cmd == "recite") then
    return true  -- Not our command
end
actor:send("In a flash of blinding light, you find yourself wisked away.")
self.room:send_except(actor, "In a flash of blinding light, " .. tostring(actor.name) .. " disappears!")
actor:teleport(get_room(100, 1))
actor:command("look")