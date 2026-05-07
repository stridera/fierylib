-- Trigger: Brownie girl gives you a flower
-- Zone: 615, ID: 28
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #61528

-- Converted from DG Script #61528: Brownie girl gives you a flower
-- Original: MOB trigger, flags: GREET, probability: 35%

-- 35% chance to trigger
if not percent_chance(35) then
    return true
end
if actor.is_player and actor.level < 100 and globals.gave_flower ~= 1 then
    wait(1)
    self:command("smile " .. tostring(actor.name))
    wait(2)
    self:command("remove buttercup")
    self:command("give buttercup " .. tostring(actor.name))
    globals.gave_flower = 1
    wait(2)
    if actor.room ~= self.room then
        return true
    end
    actor:send(tostring(self.name) .. " curtseys daintily before you.")
    self.room:send_except(actor, tostring(self.name) .. " curtseys daintily before " .. tostring(actor.name) .. ".")
end