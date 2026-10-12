-- Trigger: leviathan fight
-- Zone: 484, ID: 235
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48635

-- Converted from DG Script #48635: leviathan fight
-- Original: MOB trigger, flags: FIGHT, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
wait(2)
local mode = random(1, 10)
if mode < 6 then
    self:command("sweep")
else
    local victim = self.room.actors[random(1, #self.room.actors)]
    if (victim.name ~= actor.name) and ((victim.class == "warrior") or (string.find(victim.class, "anti")) or (victim.class == "ranger") or (victim.class == "paladin") or (victim.class == "monk") or (victim.class == "mercenary") or (victim.class == "berserker")) then
        if victim.room == self.room then
            self:teleport(get_room(11, 0))
            self:teleport(actor.room)
            self.room:send("<b:white>The Leviathan thrashes about madly, switching opponents!</>")
            combat.engage(self, victim.name)
        end
    end
end