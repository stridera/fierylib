-- Trigger: catherine_lead
-- Zone: 43, ID: 40
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #4340

-- Converted from DG Script #4340: catherine_lead
-- Original: MOB trigger, flags: LOAD, probability: 100%
if world.count_mobiles("4310") < 1 then
    self.room:spawn_mobile(43, 10)
    self.room:find_actor("theo"):spawn_object(43, 12)
    self.room:find_actor("theo"):spawn_object(502, 5)
    self.room:find_actor("theo"):spawn_object(0, 38)
    self.room:find_actor("theo"):spawn_object(43, 17)
    self.room:find_actor("theo"):command("wear all")
    self.room:find_actor("theo"):follow(self.room:find_actor("lauren"))
    self:follow(self.room:find_actor("theo"))
end