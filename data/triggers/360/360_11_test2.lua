-- Trigger: test2
-- Zone: 360, ID: 11
-- Type: WORLD, Flags: COMMAND, RESET, PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #36011

-- Converted from DG Script #36011: test2
-- Original: WORLD trigger, flags: COMMAND, RESET, PREENTRY, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
self.room:find_actor("girbina"):say("Yer mama")
self.room:send("debug2")