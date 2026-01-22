-- Trigger: test_trigger
-- Zone: 188, ID: 4
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #18804

-- Converted from DG Script #18804: test_trigger
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local var = 50
self.room:send("var is " .. tostring(var))
if var >= 1 then
    self.room:send("var more than 0")
    if var <= 99 then
        self.room:send("var less than 100")
    end
end