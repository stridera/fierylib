-- Trigger: TD PY Normalize
-- Zone: 49, ID: 6
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4906
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%
--
-- Catches the partial command "xcaptur" on a pylon. Returning true allows
-- DG's abbreviation match to expand it to "xcapture", which 049_07 then
-- handles. Pass-through; no logic by design.

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

if cmd ~= "xcaptur" then
    return true
end

return true
