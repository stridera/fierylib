-- Trigger: ambush
-- Zone: 87, ID: 10
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #8710

-- Converted from DG Script #8710: ambush
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: drag
if not (cmd == "drag") then
    return true  -- Not our command
end
self.room:send("checking..")
if random(1, 10) < 2 then
    self.room:send("proc")
end