-- Trigger: Phase Mace attack counter and damage
-- Zone: 3, ID: 19
-- Type: OBJECT, Flags: ATTACK
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #319

-- Converted from DG Script #319: Phase Mace attack counter and damage
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
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
    if victim.composition == "ether" and victim.lifeforce == "undead" then
        -- switch on self.id
        if self.id == 340 or self.id == 341 then
            return _return_value
        elseif self.id == 342 or self.id == 343 or self.id == 344 or self.id == 345 then
            local spell = "'divine bolt'"
        elseif self.id == 346 or self.id == 347 or self.id == 348 or self.id == 349 then
            local spell = "'divine ray'"
        end
        spells.cast(self, "%spell% %victim%", skill, self.level)
    elseif victim.lifeforce == "undead" or victim.lifeforce == "demonic" or victim.race == "demon" then
        local skill = skill / 2
        -- switch on self.id
        if self.id == 340 or self.id == 341 or self.id == 342 then
            return _return_value
        elseif self.id == 343 or self.id == 344 or self.id == 345 or self.id == 346 or self.id == 347 or self.id == 348 or self.id == 349 then
            local spell = "'divine bolt'"
        end
        spells.cast(self, "%spell% %victim%", skill, self.level)
    end
end