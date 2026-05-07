-- Trigger: triaszp_helpers
-- Zone: 533, ID: 2
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #53302
--
-- Tri-Aszp combat behavior: 30% per round chance to perform a special
-- action: frost breath, sweep, roar (and summon baby dragons), or growl.

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
wait(1)
local value = random(1, 10)
if value == 1 then
    self:breath_attack("frost", nil)
elseif value == 2 or value == 3 then
    self:command("sweep")
elseif value == 4 or value == 5 then
    self:command("roar")
elseif value == 8 or value == 9 then
    if world.count_mobiles(533, 1) < 6 then
        local victim = room.actors[random(1, #room.actors)]
        self:emote("hisses in anger, calling to her children.")
        wait(1)
        self.room:spawn_mobile(533, 1)
        local baby = self.room:find_actor("baby-dragon")
        if baby then
            baby:emote("scampers in and attacks!")
            if victim and victim.is_player then
                baby:command("kill " .. tostring(victim.name))
            else
                baby:command("kill " .. tostring(actor.name))
            end
        end
    end
else
    self:command("growl")
end
