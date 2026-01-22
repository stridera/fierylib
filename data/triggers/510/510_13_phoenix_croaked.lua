-- Trigger: phoenix_croaked
-- Zone: 510, ID: 13
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #51013

-- Converted from DG Script #51013: phoenix_croaked
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send("The phoenix closes its eyes and bursts into flame!")
self.room:spawn_object(510, 28)
actor:award_exp(-28000)
return _return_value