-- Trigger: UNUSED
-- Zone: 18, ID: 66
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1866

-- Converted from DG Script #1866: UNUSED
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: give 100 copper hunter
-- TODO(parity): legacy DG matched the literal full pattern "give 100 copper hunter"
-- (a give command with three trailing args). Re-validate intent — if the bribe
-- system already routes coin-give events through BRIBE, this trigger is dead.
if cmd ~= "give" then
    return true  -- Not our command
end
self:say("thank you :>")