-- Trigger: death_of_tree
-- Zone: 520, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #52007

-- Converted from DG Script #52007: death_of_tree
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
self.room:spawn_object(520, 34)
self:emote("whispers 'Ah, the relief...'")
_return_value = false
return _return_value