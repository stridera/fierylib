-- Trigger: Spark pixy offers help
-- Zone: 615, ID: 4
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #61504

-- TODO(parity): Original DG condition combined direction == "north"
-- with a heart_inplace global; the converter mangled it into a single
-- string.find call. Approximation below: greet on entry from south
-- (direction == "north" means the actor walked north into this room)
-- when the menhir light is not yet active.
local _return_value = true
if direction == "north" and globals.heart_inplace ~= 1 and actor.is_player and actor.level < 100 then
    wait(1)
    if actor.room ~= self.room then
        return _return_value
    end
    self.room:send_except(actor, tostring(self.name) .. " bows before " .. tostring(actor.name) .. " (as much as a flying pixie can).")
    actor:send(tostring(self.name) .. " bows before you, rather well for someone flying in midair.")
    wait(1)
    if actor.room ~= self.room then
        return _return_value
    end
    self:say("If you're having trouble with the fog, I might be able to help.")
    self:say("Would you like me to help?")
    globals.person_to_help = actor.name
    globals.greeted_someone = 1
    wait(1)
end
return _return_value