-- Trigger: shroom-attack
-- Zone: 237, ID: 5
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #23705

-- Converted from DG Script #23705: shroom-attack
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: get
if not (cmd == "get") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
local rightobj = 0
if string.find(arg, "mushroom") then
    rightobj = 1
end
if string.find(arg, "pink") then
    rightobj = 1
end
if string.find(arg, "purple") then
    rightobj = 1
end
if string.find(arg, "fungus") then
    rightobj = 1
end
if string.find(arg, "bulb") then
    rightobj = 1
end
if string.find(arg, "cap") then
    rightobj = 1
end
if rightobj == 1 then
    combat.engage(self, actor.name)
else
    _return_value = false
end
return _return_value