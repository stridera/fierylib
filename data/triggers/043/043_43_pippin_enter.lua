-- Trigger: pippin_enter
-- Zone: 43, ID: 43
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4343

-- Converted from DG Script #4343: pippin_enter
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: order
if not (cmd == "order") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if (actor:has_equipped(43, 18) or actor:has_item(43, 18)) and (self.room == get_room(43, 33)) and (arg == "pippin enter box") then
    self:command("enter box")
else
    _return_value = true
end
return _return_value