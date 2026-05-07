-- Trigger: new trigger
-- Zone: 0, ID: 4
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4
-- COMMAND trigger: intercepts the "kneel" command and announces it to the room.
-- TODO(parity): original DG probability was 0% (effectively disabled). If this
--               trigger should remain disabled, remove it from the mob's script
--               list rather than gating on a 0% roll here.

-- Command filter: kneel
if cmd ~= "kneel" then
    return true  -- Not our command, allow normal handling
end

self.room:send("Command trigger (cackle) running")
return true
