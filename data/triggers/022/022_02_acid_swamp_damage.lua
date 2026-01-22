-- Trigger: Acid_swamp_damage
-- Zone: 22, ID: 2
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #2202

-- Converted from DG Script #2202: Acid_swamp_damage
-- Original: WORLD trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
local count = self.actor_count
if count > 3 then
    local count = 3
end
while count > 0 do
    local victim = room.actors[random(1, #room.actors)]
    if victim.id ~= 2213 then
        local damage = 50 + random(1, 30)
        local which = random(1, 2)
        -- switch on which
        if which == 1 then
            local damage_dealt = victim:damage(damage)  -- type: poison
            victim:send("You accidentally inhale some noxious gases!  Oops! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " suddenly chokes, coughing on the acrid swamp gases. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        elseif which == 2 then
            local damage_dealt = victim:damage(damage)  -- type: acid
            victim:send("A large bubble pops in the waters, spewing acid on you! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, "A large bubble pops in the waters, spewing burning acid on " .. tostring(victim.name) .. "! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        else
        end
    end
    local count = count - 1
    wait(3)
end