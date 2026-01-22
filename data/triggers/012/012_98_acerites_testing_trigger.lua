-- Trigger: acerites_testing_trigger
-- Zone: 12, ID: 98
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1298

-- Converted from DG Script #1298: acerites_testing_trigger
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: fire
if not (cmd == "fire") then
    return true  -- Not our command
end
-- (placeholder trigger)