-- Trigger: leviathan fight
-- Zone: 486, ID: 35
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
    local victim = room.actors[random(1, #room.actors)]
    if (victim.name ~= actor.name) and ((victim.class == "Warrior") or (string.find(victim.class, "Anti")) or (victim.class == "Ranger") or (victim.class == "Paladin") or (victim.class == "Monk") or (victim.class == "Mercenary") or (victim.class == "Berserker")) then
        if victim.room == self.room then
            self:teleport(get_room(11, 0))
            self:teleport(get_room(vnum_to_zone(actor.room), vnum_to_local(actor.room)))
            self.room:send("<b:white>The Leviathan thrashes about madly, switching opponents!</>")
            combat.engage(self, victim.name)
        end
    end
end