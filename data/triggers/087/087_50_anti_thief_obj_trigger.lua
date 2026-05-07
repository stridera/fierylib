-- Trigger: anti_thief_obj_trigger
-- Zone: 87, ID: 50
-- Type: OBJECT, Flags: WEAR
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #8750
--
-- TODO(parity): legacy DG script returned 1 (allow) when actor IS a thief while
-- printing "You cannot use ..."  -- almost certainly an inverted-return bug in
-- the original. Verify intended semantics (block thieves, allow others) and
-- swap the returns. Currently faithful to legacy: thief sees the message but
-- wear is allowed; non-thief is blocked.

-- Converted from DG Script #8750: anti_thief_obj_trigger
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if string.find(actor.class, "thief") then
    actor:send("You cannot use " .. tostring(self.shortdesc) .. ".")
    return true
end
return false
