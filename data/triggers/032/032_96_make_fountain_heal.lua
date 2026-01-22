-- Trigger: Make_Fountain_heal
-- Zone: 32, ID: 96
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3296

-- Converted from DG Script #3296: Make_Fountain_heal
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if arg == "pool" or arg == "granite" then
    actor:heal(400)
    _return_value = false
end
return _return_value