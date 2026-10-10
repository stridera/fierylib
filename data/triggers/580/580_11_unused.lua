-- Trigger: **UNUSED**
-- Zone: 580, ID: 11
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Unused stub from legacy DG #58011; preserved so import keeps the slot
-- and so a future rewrite can drop in real behaviour without renumbering.

-- Command filter: p
if not (cmd == "p") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value