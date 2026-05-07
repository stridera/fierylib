-- Trigger: prevent recite
-- Zone: 300, ID: 3
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30003

-- Converted from DG Script #30003: prevent recite
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: any abbreviation of "recite"
-- Allow "r" or "re" (which match many other commands) to pass through; only
-- block when the player explicitly typed enough of "recite" to be unambiguous.
if cmd == "r" or cmd == "re" then
    return true
end
if cmd ~= "recite" and cmd ~= "rec" and cmd ~= "reci" and cmd ~= "recit" then
    return true  -- Not our command
end
actor:send("You cannot recite scrolls in a shop or guild!")
return false