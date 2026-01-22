-- Trigger: white_mask_wear
-- Zone: 87, ID: 58
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #8758

-- Converted from DG Script #8758: white_mask_wear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
wait(1)
actor.name:send("As you place the white mask to your face, it starts to flow untill it conforms to your face.")
self.room:send_except(actor.name, "a white mask flows like liquid as it conforms to " .. tostring(actor.name) .. "'s face.")
_return_value = true
return _return_value