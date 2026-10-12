-- Trigger: lylaith
-- Zone: 12, ID: 65
-- Type: OBJECT, Flags: RANDOM, COMMAND, WEAR
-- Status: CLEAN
--
-- Original DG Script: #1265

-- Converted from DG Script #1265: lylaith
-- Original: OBJECT trigger, flags: RANDOM, COMMAND, WEAR, num_arg: 15 (no chance roll in legacy)


-- Command filter: lylaith
if not (cmd == "lylaith") then
    return true  -- Not our command
end
self.room:send("The blade of " .. tostring(self.shortdesc) .. " flares a <b:white>bright white</>.")