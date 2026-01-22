-- Trigger: Balor_death
-- Zone: 22, ID: 0
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2200

-- Converted from DG Script #2200: Balor_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send("As " .. tostring(actor.name) .. " slays the Balor, the demon splits open with a bright crack!")
run_room_trigger(2201)
self:destroy_item("balor-sword")
self:destroy_item("flame-whip")
return _return_value