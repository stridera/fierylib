-- Trigger: A mild avalanche
-- Zone: 302, ID: 4
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #30204

-- Converted from DG Script #30204: A mild avalanche
-- Original: WORLD trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
-- Starts an avalanche. One player in the room is targeted, and will be
-- smacked by a rock and moved to a downhill room unless they escape.
-- Applied to: r30216, r30220, r30230, r30234, r30239, r30244
local victim = room.actors[random(1, #room.actors)]
if victim == 0 or victim.id ~= -1 then
    return _return_value
end
local startroom = victim.room
self.room:send("A quiet noise from above attracts your attention.")
wait(2)
self.room:send("A few small pebbles and stones are falling down the hillside.")
self.room:send("They clatter as they tumble.")
wait(2)
self.room:send("Large rocks are tumbling past you!  They look heavy!")
wait(1)
local destroom
if self.id == 30234 then
    destroom = self.id + 1
else
    destroom = self.id - 1
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
            victim:teleport(get_room(vnum_to_zone(destroom), vnum_to_local(destroom)))
            self.room:send_except(victim, tostring(victim.name) .. " tumbles down the trail from above, and comes to a rest.")
            wait(1)
            -- victim looks around
        end
    end
end
self.room:send("The remnants of the avalanche tumble past, and then silence returns to the mountains.")