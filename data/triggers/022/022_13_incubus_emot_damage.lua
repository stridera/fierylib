-- Trigger: Incubus_Emot_Damage
-- Zone: 22, ID: 13
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2213

-- Converted from DG Script #2213: Incubus_Emot_Damage
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local dice = random(1, 50)
local damage = 100 + dice
local victim = room.actors[random(1, #room.actors)]
if victim.id == -1 then
    if victim.gender == "Female" then
        self.room:send_except(victim, "The Incubus grabs hold of " .. tostring(victim.name) .. " and gives her a passionate kiss. (<blue>" .. tostring(damage) .. "</>)")
        victim:send("The Incubus grabs you tenderly and gives you an amazingly passionate kiss... (<b:red>" .. tostring(damage) .. "</>)")
        local damage_dealt = victim:damage(damage)  -- type: physical
    end
end