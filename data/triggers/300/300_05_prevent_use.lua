-- Trigger: prevent use
-- Zone: 300, ID: 5
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30005

-- Converted from DG Script #30005: prevent use
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: "use" (allow bare "u" which can match other commands)
if cmd == "u" then
    return true
end
if cmd ~= "use" and cmd ~= "us" then
    return true  -- Not our command
end
actor:send("You cannot use wands or staves in a shop or guild!")
return false