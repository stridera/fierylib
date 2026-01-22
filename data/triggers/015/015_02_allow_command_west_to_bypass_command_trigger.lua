-- Trigger: Allow command "west" to bypass command trigger
-- Zone: 15, ID: 2
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1502

-- Converted from DG Script #1502: Allow command "west" to bypass command trigger
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: we
if not (cmd == "we") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value