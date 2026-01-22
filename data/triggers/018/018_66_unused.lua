-- Trigger: UNUSED
-- Zone: 18, ID: 66
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1866

-- Converted from DG Script #1866: UNUSED
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: give 100 copper hunter
if not (cmd == "give" or cmd == "100" or cmd == "copper" or cmd == "hunter") then
    return true  -- Not our command
end
self:say("thank you :>")