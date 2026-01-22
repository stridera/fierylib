-- Trigger: prevent recite
-- Zone: 300, ID: 3
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30003

-- Converted from DG Script #30003: prevent recite
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: recite
if not (cmd == "recite") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "r" or cmd == "re" then
    _return_value = false
    return _return_value
end
_return_value = true
actor:send("You cannot recite scrolls in a shop or guild!")
return _return_value