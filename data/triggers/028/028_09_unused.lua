-- Trigger: **UNUSED**
-- Zone: 28, ID: 9
-- Type: OBJECT, Flags: COMMAND
-- Status: REVIEWED (UNUSED; no-op stub)
--
-- Original DG Script: #2809
-- Stub: original was a 3%-chance "examine" command interceptor with no body.
-- Behavior is to always allow the command. Kept for parity with the
-- legacy dataset.
-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

return true