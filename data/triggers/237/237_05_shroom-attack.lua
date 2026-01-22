-- Trigger: shroom-attack
-- Zone: 237, ID: 5
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #23705

-- Converted from DG Script #23705: shroom-attack
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: get
if not (cmd == "get") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if string.find(arg, "mushroom") then
    local rightobj = 1
end
if string.find(arg, "pink") then
    local rightobj = 1
end
if arg /=purple then
    local rightobj = 1
end
if string.find(arg, "fungus") then
    local rightobj = 1
end
if string.find(arg, "bulb") then
    local rightobj = 1
end
if string.find(arg, "cap") then
    local rightobj = 1
end
if rightobj ==1 then
    combat.engage(self, actor.name)
else
    _return_value = false
end
return _return_value