-- Trigger: Shadow Doom 1
-- Zone: 0, ID: 8
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8
-- Greets eastbound players with a badge spawn, gives the badge to them,
-- then closes and locks the gate to the east behind them.

if actor.is_player and direction == "east" then
    self.room:spawn_object(90, 36)
    self:command("give badge " .. tostring(actor.name))
    self:command("close gate east")
    self:command("lock gate east")
end
