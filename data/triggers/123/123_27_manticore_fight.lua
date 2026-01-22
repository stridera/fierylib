-- Trigger: manticore_fight
-- Zone: 123, ID: 27
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #12327

-- Converted from DG Script #12327: manticore_fight
-- Original: MOB trigger, flags: FIGHT, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
wait(2)
if actor and (actor.room == self.room) and (actor.id == -1) then
    local hit = (self.hitroll + random(1, 100)) + (actor.armor + ((actor.real_dex / 2) - 24))
    if hit >= 0 then
        self.room:send("A manticore lashes out with its tail!")
        spells.cast(self, "poison", actor, self.level)
    else
        self.room:send_except(actor, tostring(self.name) .. " misses " .. tostring(actor.name) .. " with a powerful thrust of its tail!")
        actor:send(tostring(self.name) .. " misses you with a powerful thrust of its tail!")
    end
end