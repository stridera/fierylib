-- Trigger: Witch_receive
-- Zone: 105, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #10504
-- Reward the player based on which mushroom they hand over:
--   (105, 9)  bad mushroom  -> give them food (waybread) instead
--   (105, 8)  fair mushroom -> cast armor on them
--   (105, 7)  good mushroom -> cast cure critic on them
-- Anything else: just eye the actor.
self:say("thanks " .. tostring(actor.alias))
if object.zone_id == 105 and object.local_id == 9 then
    wait(1)
    self:destroy_item("mushroom")
    spells.cast(self, "create food")
    self.room:spawn_object(105, 10)
    wait(3)
    self:command("give mushroom " .. tostring(actor.name))
    self:command("give waybread " .. tostring(actor.name))
    self:say("Thanks for the thought, but thats no good for me.")
elseif object.zone_id == 105 and object.local_id == 8 then
    wait(1)
    self:destroy_item("mushroom")
    spells.cast(self, "armor", actor.name)
    self:command("thank " .. tostring(actor.name))
elseif object.zone_id == 105 and object.local_id == 7 then
    wait(1)
    self:command("junk mushroom")
    self:command("thank " .. tostring(actor.name))
    spells.cast(self, "cure crit", actor.name)
else
    wait(1)
    self:command("eye " .. tostring(actor.name))
end