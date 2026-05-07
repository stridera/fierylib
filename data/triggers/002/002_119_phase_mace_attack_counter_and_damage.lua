-- Trigger: Phase Mace attack counter and damage
-- Zone: 2, ID: 119
-- Type: OBJECT, Flags: ATTACK
--
-- Counts attacks toward the phase_mace bonding milestone (macetask1 at
-- stage * 50 hits) and, on roughly 75% of hits, casts a divine spell whose
-- power scales with mace stage:
--   - vs ethereal undead: divine bolt (340-345) or divine ray (346-349)
--   - vs other undead/demonic targets: divine bolt at half skill (343+)
if actor:get_quest_stage("phase_mace") >= 1 then
    if not actor:get_quest_var("phase_mace:macetask1") then
        local attack_increase = actor:get_quest_var("phase_mace:attack_counter") + 1
        actor:set_quest_var("phase_mace", "attack_counter", attack_increase)
        if actor:get_quest_var("phase_mace:attack_counter") >= actor:get_quest_stage("phase_mace") * 50 then
            actor:set_quest_var("phase_mace", "macetask1", 1)
            actor:send("<b:white>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end
if random(1, 4) > 1 then
    local skill = self.level
    local spell
    if victim.composition == "ether" and victim.lifeforce == "undead" then
        if self.id == 340 or self.id == 341 then
            return true
        elseif self.id == 342 or self.id == 343 or self.id == 344 or self.id == 345 then
            spell = "divine bolt"
        elseif self.id == 346 or self.id == 347 or self.id == 348 or self.id == 349 then
            spell = "divine ray"
        end
        if spell then
            spells.cast(self, spell, victim, skill)
        end
    elseif victim.lifeforce == "undead" or victim.lifeforce == "demonic" or victim.race == "demon" then
        skill = skill / 2
        if self.id == 340 or self.id == 341 or self.id == 342 then
            return true
        elseif self.id >= 343 and self.id <= 349 then
            spell = "divine bolt"
        end
        if spell then
            spells.cast(self, spell, victim, skill)
        end
    end
end
