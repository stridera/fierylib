-- Trigger: Witch_receive
-- Zone: 105, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #10504

-- Converted from DG Script #10504: Witch_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
self:say("thanks " .. tostring(actor.alias))
-- This is the cute little script that gives players
-- spells for their efforts.
if object.id == 10509 then
    wait(1)
    self:destroy_item("mushroom")
    spells.cast(self, "create food")
    self.room:spawn_object(105, 10)
    wait(3)
    self:command("give mushroom " .. tostring(actor.name))
    self:command("give waybread " .. tostring(actor.name))
    self:say("Thanks for the thought, but thats no good for me.")
else
    if object.id == 10508 then
        wait(1)
        self:destroy_item("mushroom")
        spells.cast(self, "armor", actor.name)
        self:command("thank " .. tostring(actor.name))
    else
        if object.id == 10507 then
            wait(1)
            self:command("junk mushroom")
            self:command("thank " .. tostring(actor.name))
            spells.cast(self, "cure crit", actor.name)
        else
            wait(1)
            self:command("eye " .. tostring(actor.name))
        end
    end
end