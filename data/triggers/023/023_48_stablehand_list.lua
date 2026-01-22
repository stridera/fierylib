-- Trigger: stablehand_list
-- Zone: 23, ID: 48
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2348

-- Converted from DG Script #2348: stablehand_list
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: list
if not (cmd == "list") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = true
actor:send("Available pets are:")
actor:send("a steady warhorse - <yellow>40</> c")
return _return_value