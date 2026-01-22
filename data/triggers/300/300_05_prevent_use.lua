-- Trigger: prevent use
-- Zone: 300, ID: 5
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30005

-- Converted from DG Script #30005: prevent use
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: use
if not (cmd == "use") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "u" then
    _return_value = false
    return _return_value
end
_return_value = true
actor:send("You cannot use wands or staves in a shop or guild!")
return _return_value