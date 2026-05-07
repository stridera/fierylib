-- Trigger: Hell Trident attack manager
-- Zone: 2, ID: 110
-- Type: OBJECT, Flags: ATTACK
--
-- Adds bonus alignment damage (50% of base damage vs neutral, 100% vs good
-- targets), occasionally casts hell-themed spells, and counts attacks toward
-- the hell_trident quest "blood offering" milestone (helltask1 at 666 hits).
if victim.hit >= -10 then
    -- 5% alignment damage against neutral targets, 10% against good
    if damage >= 1 then
        local bonus = 0
        if victim.alignment < 350 and victim.alignment > -350 then
            bonus = damage / 2
        elseif victim.alignment > 350 then
            bonus = damage
        end
        if bonus > 0 then
            self.room:send("&9<blue>" .. tostring(self.shortdesc) .. " smites " .. tostring(victim.name) .. " with unholy might!</> (<yellow>" .. tostring(bonus) .. "</>)")
            victim:damage(bonus)  -- type: align
        end
    end
    if random(1, 10) == 1 then
        if self.id == 2339 then
            spells.cast(self, "hell bolt", victim, self.level)
        elseif self.id == 2340 then
            spells.cast(self, "stygian eruption", victim, self.level)
        end
    end
end
if actor:get_quest_stage("hell_trident") == 1 or actor:get_quest_stage("hell_trident") == 2 then
    if not actor:get_quest_var("hell_trident:helltask1") then
        local attack_increase = actor:get_quest_var("hell_trident:attack_counter") + 1
        actor:set_quest_var("hell_trident", "attack_counter", attack_increase)
        if actor:get_quest_var("hell_trident:attack_counter") >= 666 then
            actor:set_quest_var("hell_trident", "helltask1", 1)
            actor:set_quest_var("hell_trident", "attack_counter", 0)
            actor:send("<b:red>You have made sufficient blood offerings with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end
