-- Trigger: A mild avalanche
-- Zone: 302, ID: 4
-- Type: WORLD, Flags: RANDOM
-- Status: NEEDS_REVIEW
--   TODO: Confirm avalanche destination rooms — original used `self.id ± 1`
--   on legacy room vnums. Mapping (legacy -> dest):
--     30216 -> 30215, 30220 -> 30219, 30230 -> 30229,
--     30234 -> 30235, 30239 -> 30238, 30244 -> 30243.
--   In zone-local terms (zone 302) that's source.id -> source.id - 1 except
--   r30234 which goes uphill (+1). Verify against world data.
--
-- Original DG Script: #30204
-- Starts an avalanche. One player in the room is targeted, and will be
-- smacked by a rock and moved to a downhill room unless they escape.
-- Applied to: r30216, r30220, r30230, r30234, r30239, r30244

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if #room.actors == 0 then
    return true
end
local victim = room.actors[random(1, #room.actors)]
if not victim or victim.is_npc then
    return true
end
local startroom = victim.room
self.room:send("A quiet noise from above attracts your attention.")
wait(2)
self.room:send("A few small pebbles and stones are falling down the hillside.")
self.room:send("They clatter as they tumble.")
wait(2)
self.room:send("Large rocks are tumbling past you!  They look heavy!")
wait(1)
local dest_local
if self.id == 34 then
    dest_local = self.id + 1
else
    dest_local = self.id - 1
end
local damage
if victim.level < 10 then
    damage = 3 + random(1, 5)
elseif victim.level < 20 then
    damage = 10 + random(1, 8)
elseif victim.level < 40 then
    damage = 30 + random(1, 30)
else
    damage = 80 + random(1, 50)
end
if victim.room == startroom then
    if victim.class == "Ranger" then
        self.room:send_except(victim, tostring(victim.name) .. " is nearly smacked by a large rock, but " .. tostring(victim.name) .. " steps aside at the last moment.")
        victim:send("A big rock comes hurtling toward you, but you step smoothly aside.")
    else
        local damage_dealt = victim:damage(damage)  -- type: crush
        if damage_dealt == 0 then
            self.room:send_except(victim, "The rocks seem to pass right through " .. tostring(victim.name) .. ".")
            victim:send("The rocks seem to pass right through you.")
        else
            self.room:send_except(victim, "A big rock hits " .. tostring(victim.name) .. " right in the chest, and " .. tostring(victim.name) .. " is knocked over! (<blue>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " tumbles downhill!")
            victim:send("You try to dodge the boulders, but a large stone whacks you in the chest! (<red>" .. tostring(damage_dealt) .. "</>)")
            victim:send("You are knocked down!")
            victim:teleport(get_room(302, dest_local))
            self.room:send_except(victim, tostring(victim.name) .. " tumbles down the trail from above, and comes to a rest.")
            wait(1)
        end
    end
end
self.room:send("The remnants of the avalanche tumble past, then silence returns to the mountains.")