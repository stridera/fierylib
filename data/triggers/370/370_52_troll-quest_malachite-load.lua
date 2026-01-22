-- Trigger: troll-quest_malachite-load
-- Zone: 370, ID: 52
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #37052

-- Converted from DG Script #37052: troll-quest_malachite-load
-- Original: MOB trigger, flags: GREET, probability: 100%
if string.find(actor.race, "troll") or actor:get_quest_stage("acid_wand") == 7 then
    self:destroy_item("malachite")
    self.room:spawn_object(370, 82)
end