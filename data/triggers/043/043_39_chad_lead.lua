-- Trigger: chad_lead
-- Zone: 43, ID: 39
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4339

-- Converted from DG Script #4339: chad_lead
-- Original: MOB trigger, flags: RANDOM, probability: 100%
if world.count_mobiles("4302") < 1 then
    self.room:spawn_mobile(43, 2)
    wait(1)
    self.room:find_actor("nick"):spawn_object(43, 12)
    self.room:find_actor("nick"):spawn_object(43, 13)
    self.room:find_actor("nick"):spawn_object(43, 14)
    self.room:find_actor("nick"):spawn_object(43, 15)
    self.room:find_actor("nick"):spawn_object(43, 16)
    self.room:find_actor("nick"):spawn_object(43, 17)
    self.room:find_actor("nick"):command("wear all")
    self.room:find_actor("nick"):follow(self.room:find_actor("chad"))
    self:follow(self.room:find_actor("nick"))
end