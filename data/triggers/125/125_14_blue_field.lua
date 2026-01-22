-- Trigger: Blue_field
-- Zone: 125, ID: 14
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12514

-- Converted from DG Script #12514: Blue_field
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
actor:damage(115)  -- type: shock
if damage_dealt == 0 then
    _return_value = false
else
    _return_value = true
    actor:send("The blue field shocks you, flinging you back into the room! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(actor, tostring(actor.name) .. " is forced back by the blue field. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
end
return _return_value