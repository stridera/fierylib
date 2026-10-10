-- Trigger: sulk_and_south
-- Zone: 12, ID: 61
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1261

-- Converted from DG Script #1261: sulk_and_south
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: sulk
if not (cmd == "sulk") then
    return true  -- Not our command
end
-- TODO: original DG body unknown; converter produced no-op. Allow action.
return true