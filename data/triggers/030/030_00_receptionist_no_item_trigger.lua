-- Trigger: Receptionist_no_item_trigger
-- Zone: 30, ID: 0
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #3000

-- Converted from DG Script #3000: Receptionist_no_item_trigger
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
actor:send(tostring(self.name) .. " says, 'I'm sorry, but I cannot accept this.'")
actor:send(tostring(self.name) .. " refuses your item.")
return _return_value