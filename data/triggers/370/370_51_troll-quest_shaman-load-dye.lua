-- Trigger: troll-quest_shaman-load-dye
-- Zone: 370, ID: 51
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #37051

-- Converted from DG Script #37051: troll-quest_shaman-load-dye
-- Original: MOB trigger, flags: GREET, probability: 100%
if string.find(actor.race, "troll") then
    self:destroy_item("red-dye")
    self.room:spawn_object(370, 81)
end