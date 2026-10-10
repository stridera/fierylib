-- Trigger: valentine_box_open
-- Zone: 12, ID: 46
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1246

-- Converted from DG Script #1246: valentine_box_open
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- Command location mask 2: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: open box
if not (cmd == "open" or cmd == "box") then
    return true  -- Not our command
end
self.room:send(tostring(arg))