-- Trigger: lord-realm fight
-- Zone: 484, ID: 8
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48408

-- Converted from DG Script #48408: lord-realm fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if has_blur then
    if not (self:has_effect(Effect.Blur)) then
        self:emote("slows as " .. tostring(self.name) .. " returns to normal speed.")
        local has_blur = 0
        globals.has_blur = globals.has_blur or true
    end
end
local victim = room.actors[random(1, #room.actors)]
if victim then
    local action = random(1, 10)
    if action > 8 then
        wait(2)
        self.room:send_except(victim, tostring(self.name) .. " swings a rocky fist at " .. tostring(victim.name) .. ", toppling " .. tostring(victim.object) .. "!")
        victim:send(tostring(self.name) .. " swings a rocky fist at you, knocking you over!")
        self:send("You swing a rocky fist at " .. tostring(victim.name) .. ", knocking " .. tostring(victim.object) .. " over!")
        victim:teleport(get_room(11, 0))
        victim:command("recline")
        victim:teleport(get_room(vnum_to_zone(self.room), vnum_to_local(self.room)))
    elseif action > 7 then
        if victim.id == -1 then
            combat.engage(self, victim.name)
        end
    end
end