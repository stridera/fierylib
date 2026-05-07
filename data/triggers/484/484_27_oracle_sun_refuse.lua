-- Trigger: Oracle Sun refuse
-- Zone: 484, ID: 27
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48427

-- Converted from DG Script #48427: Oracle Sun refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- TODO(parity): the original script gates acceptance on a list of DG
--   global tokens (%maceitem2%, %wand_id%, etc.) that named specific quest
--   items. The mapping from those tokens to new (zone, id) keys is not
--   yet available, so every gift is currently refused. Restore the
--   accept list once the item IDs are known.
local _return_value = true  -- Default: allow action
local response = "I have no need of this."
if response then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value