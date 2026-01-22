-- Trigger: nikita fight
-- Zone: 489, ID: 22
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48922

-- Converted from DG Script #48922: nikita fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local mode = random(1, 10)
if mode > 8 then
    -- 20% chance for lay hands
    local amount = 1000 + random(1, 40)
    self.room:send("The hands of Nikita glow as she lays them on herself. (<b:yellow>" .. tostring(amount) .. "</>)")
    spells.cast(self, "full heal", self, 100)
    -- Mini-wait so the trigger only goes off once per round
    wait(1)
elseif mode > 7 then
    -- 10% chance for hitall
    wait(1)
    self:attack_all()
elseif mode > 5 then
    -- 20% chance for holy word
    wait(1)
    spells.cast(self, "holy word")
end
if not (self:get_worn("2hwield")) then
    self:command("get rahmat")
    self:command("wield rahmat")
end