-- Trigger: Kerriston_north_horse_look
-- Zone: 324, ID: 7
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #32407

-- Converted from DG Script #32407: Kerriston_north_horse_look
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: l lo loo look
if not (cmd == "l" or cmd == "lo" or cmd == "loo" or cmd == "look") then
    return true  -- Not our command
end
wait(1)
self.room:send("You can't see anything, the world blurrs around you!")