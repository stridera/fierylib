-- Trigger: TD PY Normalize
-- Zone: 49, ID: 6
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4906
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%
--
-- Catches the partial command "xcaptur" on a pylon. Returning true allows
-- DG's abbreviation match to expand it to "xcapture", which 049_07 then
-- handles. Pass-through; no logic by design.

if not percent_chance(4) then
    return true
end

if cmd ~= "xcaptur" then
    return true
end

return true
