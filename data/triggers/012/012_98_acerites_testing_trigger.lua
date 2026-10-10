-- Trigger: acerites_testing_trigger
-- Zone: 12, ID: 98
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1298

-- Converted from DG Script #1298: acerites_testing_trigger
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: fire
if not (cmd == "fire") then
    return true  -- Not our command
end
-- (placeholder trigger)