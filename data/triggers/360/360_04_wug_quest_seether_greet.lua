-- Trigger: wug_quest_seether_greet
-- Zone: 360, ID: 4
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #36004

-- Converted from DG Script #36004: wug_quest_seether_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    if world.count_mobiles("8031") < 1 and actor.level < 30 then
        wait(2)
        self:command("hiss " .. tostring(actor))
        self:say("You can't have it!  You'll just break it!")
        self.room:send(tostring(self.name) .. " clutches a crystalline amulet to its chest!")
    end
end