-- Trigger: branches_attack_rand
-- Zone: 117, ID: 1
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN (fixed & to and)
--
-- Original DG Script: #11701

-- Converted from DG Script #11701: branches_attack_rand
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(2)
if actor.id == -1 and actor.level < 100 then
    local dice1 = random(1, 55)
    local dice2 = random(1, 55)
    local damage = dice1 + dice2
    local victim = room.actors[random(1, #room.actors)]
    local damage_dealt = victim:damage(damage)  -- type: slash
    if damage_dealt == 0 then
        self.room:send_except(victim, "One of the branches suddenly whips out at " .. tostring(victim.name) .. "!")
        victim:send("A gnarled tree branch reached out and tried to slash you!")
    else
        self.room:send_except(victim, "One of the branches suddenly whips out at " .. tostring(victim.name) .. ", cutting " .. tostring(victim.object) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send("A gnarled tree branch reached out and slashed you!! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
    wait(3)
end