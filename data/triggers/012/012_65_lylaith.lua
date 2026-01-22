-- Trigger: lylaith
-- Zone: 12, ID: 65
-- Type: OBJECT, Flags: RANDOM, COMMAND, WEAR
-- Status: CLEAN
--
-- Original DG Script: #1265

-- Converted from DG Script #1265: lylaith
-- Original: OBJECT trigger, flags: RANDOM, COMMAND, WEAR, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end

-- Command filter: lylaith
if not (cmd == "lylaith") then
    return true  -- Not our command
end
self.room:send("The blade of " .. tostring(self.shortdesc) .. " flares a <b:white>bright white</>.")