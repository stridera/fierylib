-- Trigger: angry-gardener_receive
-- Zone: 464, ID: 11
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #46411

-- Converted from DG Script #46411: angry-gardener_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- 
-- comment
-- 
if object.id == 18000 then
    wait(1)
    self:command("scream")
    wait(1)
    self:shout(tostring(actor.name) .. " is a murderer!  I'm going to kill them.")
    self.room:spawn_object(464, 13)
    get_room(464, 49):at(function()
        self:command("drop bracelet")
    end)
    wait(1)
    combat.engage(self, actor.name)
end  -- auto-close block