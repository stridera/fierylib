-- Trigger: white_mask_wear
-- Zone: 87, ID: 58
-- Type: OBJECT, Flags: WEAR
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #8758
--
-- TODO(parity): legacy DG 'return 1' blocks the wear after showing flavor text.
-- Typically a wear-flavor trigger should allow the wear -- verify designer intent.

-- Converted from DG Script #8758: white_mask_wear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
wait(1)
actor:send("As you place the white mask to your face, it starts to flow untill it conforms to your face.")
self.room:send_except(actor, "a white mask flows like liquid as it conforms to " .. tostring(actor.name) .. "'s face.")
return false  -- DG return 1: block wear
