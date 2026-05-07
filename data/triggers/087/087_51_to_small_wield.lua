-- Trigger: to_small_wield
-- Zone: 87, ID: 51
-- Type: OBJECT, Flags: WEAR
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #8751
--
-- TODO(parity): legacy DG returns 0 (allow) for tiny/small/medium while sending
-- "It's too big for you!" -- almost certainly an inverted-return bug.
-- Verified intent should be: small sizes are blocked, others allowed. Currently
-- preserves legacy (buggy) behavior.

-- Converted from DG Script #8751: to_small_wield
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if actor.size == "tiny" or actor.size == "small" or actor.size == "medium" then
    actor:send("It's too big for you!")
    _return_value = true
else
    _return_value = false
end
return _return_value
