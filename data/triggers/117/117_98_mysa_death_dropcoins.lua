-- Trigger: mysa_death_dropcoins
-- Zone: 117, ID: 98
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #11798

-- Converted from DG Script #11798: mysa_death_dropcoins
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send("With a mighty roar Mysa falls!!")
self.room:spawn_object(117, 98)
self:command("drop treasure")
-- (empty room echo)
self.room:send("A huge pile of treasure is now available upon the dragon's demise!")
return _return_value