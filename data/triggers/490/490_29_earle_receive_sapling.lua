-- Trigger: Earle receive sapling
-- Zone: 490, ID: 29
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49029

-- Converted from DG Script #49029: Earle receive sapling
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- sapling given back
_return_value = false
wait(4)
self:say("Keep it, " .. tostring(actor.name) .. "!  You'll need to drop it by the altar.  Otherwise you will never defeat Dagon's material form!")
wait(2)
self:emote("returns " .. tostring(object.shortdesc) .. ".")
return _return_value