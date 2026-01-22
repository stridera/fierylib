-- Trigger: belial_enervation_script
-- Zone: 22, ID: 47
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2247

-- Converted from DG Script #2247: belial_enervation_script
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- enervation spell = 375-450 random damage
local count = 3
wait(1)
self.room:send("Belial cackles madly, spreading his open hands apart!")
self.room:send("A blackened bolts of energy crackles from Belial's fingertips.")
while count > 0 do
    local victim = room.actors[random(1, #room.actors)]
    if victim.id == -1 then
        local damage = 375 + random(1, 75)
        local saved = random(1, 2)
        -- switch on saved
        if saved == 1 then
            local damage = = damage/2
            victim:send("You narrowly avoid a blackened bolt of energy! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " narrowly avoids a blackend bolt of energy! (<blue>" .. tostring(damage) .. "</>)")
        elseif saved == 2 then
            victim:send("You are hit dead on by a blackened bolt of energy! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " is hit dead on by a blackend bolt of energy! (<blue>" .. tostring(damage) .. "</>)")
        else
        end
        local damage_dealt = victim:damage(damage)  -- type: physical
    end
    local count = count - 1
end