-- Trigger: cats_eyes_wear
-- Zone: 22, ID: 94
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #2294

-- Converted from DG Script #2294: cats_eyes_wear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
wait(1)
actor.name:send("As you lift the cat's eyes towards your own, they are absorbed into your eye sockets.")
self.room:send_except(actor.name, tostring(actor.name) .. " lifts a pair of green eyes to his own, and they are absorbed into " .. tostring(actor.possessive) .. " own.")
_return_value = true
return _return_value