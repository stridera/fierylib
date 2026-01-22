-- Trigger: valentine_box_open
-- Zone: 12, ID: 46
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1246

-- Converted from DG Script #1246: valentine_box_open
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: open box
if not (cmd == "open" or cmd == "box") then
    return true  -- Not our command
end
self.room:send(tostring(arg))