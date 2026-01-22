-- Trigger: lava_death_trig
-- Zone: 52, ID: 78
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #5278

-- Converted from DG Script #5278: lava_death_trig
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(2)
while self.people do
    local dice1 = random(1, 60)
    local dice2 = random(1, 60)
    local damage = dice1 + dice2
    local victim = room.actors[random(1, #room.actors)]
    if victim then
        local damage_dealt = victim:damage(damage)  -- type: fire
        if damage_dealt == 0 then
            self.room:send_except(victim, "A large lava bubble bursts near " .. tostring(victim.name) .. ", but " .. tostring(victim.possessive) .. " body absorbs the blast!")
            victim:send("A large lava bubble bursts right next to you.  Luckily, you are well -protected.")
        else
            self.room:send_except(victim, "A large lava bubble bursts near " .. tostring(victim.name) .. ", burning " .. tostring(victim.object) .. "! (<red>" .. tostring(damage_dealt) .. "</>)")
            victim:send("A large lava bubble bursts right next to you - OUCH, that burns! (<red>" .. tostring(damage_dealt) .. "</>)")
        end
        if victim:get_quest_stage("meteorswarm") == 3 and victim:get_quest_var("meteorswarm:fire") == 1 then
            victim:advance_quest("meteorswarm")
            wait(1)
            actor:send("<red>You feel your mastery over fire growing!</>")
        end
    else
        return _return_value
    end
    wait(2)
end