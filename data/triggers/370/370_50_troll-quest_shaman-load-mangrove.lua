-- Trigger: troll-quest_shaman-load-mangrove
-- Zone: 370, ID: 50
-- Type: MOB, Flags: GREET, GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #37050

-- Converted from DG Script #37050: troll-quest_shaman-load-mangrove
-- Original: MOB trigger, flags: GREET, GREET_ALL, probability: 100%
if string.find(actor.race, "troll") then
    self:destroy_item("mangrove-branch")
    self.room:spawn_object(370, 80)
    self:say("You're a troll")
else
    self:say("You're not a troll!")
end