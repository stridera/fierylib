-- Trigger: **UNUSED**
-- Zone: 302, ID: 7
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30207

-- Allows normal use of 'd' command around red leather bag (it intercepts
-- the "drag" command in trigger 30206).
-- Applied to: o30209

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: d
if cmd ~= "d" then
    return true  -- Not our command
end
return true