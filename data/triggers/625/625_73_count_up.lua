-- Trigger: count up
-- Zone: 625, ID: 73
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #62573
--
-- TODO(parity): Companion to trigger 72 (countdown) and 74 (seagulls).
-- Periodically tops up the shared charge counter on a worn item. The
-- legacy script read DG globals (`delay`, `charges`, `maxcharge`) plus
-- `obj.worn_by`, none of which are in scope here. Needs to be ported as
-- a unit with 72/74 so the bookkeeping actually persists across calls.
-- Left as a no-op.

-- Converted from DG Script #62573: count up
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
return true
