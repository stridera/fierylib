-- Trigger: bread_purge
-- Zone: 200, ID: 35
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #20035

-- Converted from DG Script #20035: bread_purge
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: CURSED!
if not (cmd == "CURSED!") then
    return true  -- Not our command
end
self:destroy_item("bread")