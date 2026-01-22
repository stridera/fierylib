-- Trigger: Nukreth Spire tracker death follow
-- Zone: 462, ID: 33
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #46233

-- Converted from DG Script #46233: Nukreth Spire tracker death follow
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(4)
if world.count_mobiles("46201") == 0 then
    self.room:find_actor("captive"):say("Alright, who do I follow?")
end