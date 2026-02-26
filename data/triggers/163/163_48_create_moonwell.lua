-- Trigger: create_moonwell
-- Zone: 163, ID: 48
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #16348

-- Converted from DG Script #16348: create_moonwell
-- Original: WORLD trigger, flags: GLOBAL, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
self.room:spawn_object(0, 33)