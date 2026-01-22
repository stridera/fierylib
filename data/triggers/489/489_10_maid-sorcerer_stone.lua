-- Trigger: maid-sorcerer stone
-- Zone: 489, ID: 10
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48910

-- Converted from DG Script #48910: maid-sorcerer stone
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stone
if not (cmd == "stone") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == 48901 then
    local stone = 1
    globals.stone = globals.stone or true
else
    _return_value = false
end
return _return_value