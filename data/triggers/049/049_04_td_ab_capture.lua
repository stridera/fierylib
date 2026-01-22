-- Trigger: TD AB Capture
-- Zone: 49, ID: 4
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4904

-- Converted from DG Script #4904: TD AB Capture
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: capture
if not (cmd == "capture") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- Team Domination Armband Capture (Command) Trigger
if TteamT ~= "TT" then
    actor:command("xcapture T%team%T")
    _return_value = true
else
    _return_value = false
end
return _return_value