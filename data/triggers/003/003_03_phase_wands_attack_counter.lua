-- Trigger: phase wands attack counter
-- Zone: 3, ID: 3
-- Type: OBJECT, Flags: ATTACK
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #303

-- Converted from DG Script #303: phase wands attack counter
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
if self.id >= 300 and self.id <= 309 then
    local type = "air"
    if self.id >= 301 and self.id <= 305 then
        local spell = "'shocking grasp'"
        local bonus = self.id - 301
        local level = self.level
    else
        local spell = "'lightning bolt'"
        local bonus = self.id - 306
        local level = self.level - 50
    end
elseif self.id >= 310 and self.id <= 319 then
    local type = "fire"
    if self.id >= 311 and self.id <= 315 then
        local spell = "'burning hands'"
        local bonus = self.id - 311
        local level = self.level
    else
        local spell = "'fireball'"
        local bonus = self.id - 316
        local level = self.level - 50
    end
elseif self.id >= 320 and self.id <= 329 then
    local type = "ice"
    if self.id >= 321 and self.id <= 325 then
        local spell = "'chill touch'"
        local bonus = self.id - 321
        local level = self.level
    else
        local spell = "'cone of cold'"
        local bonus = self.id - 326
        local level = self.level - 50
    end
elseif self.id >= 330 and self.id <= 339 then
    local type = "acid"
    if self.id >= 331 and self.id <= 335 then
        local spell = "'writhing weeds'"
        local bonus = self.id - 331
        local level = self.level
    else
        local spell = "'acid burst'"
        local bonus = self.id - 336
        local level = self.level - 50
    end
end
if actor.quest_stage[type_wand] > 1 then
    if not actor.quest_variable[type_wand:wandtask1] then
        local attack_increase = actor.quest_variable[type_wand:attack_counter] + 1
        actor.name:set_quest_var("%type%_wand", "attack_counter", attack_increase)
        if actor.quest_variable[type_wand:attack_counter] >= (actor.quest_stage[type_wand] - 1) * 50 then
            actor:set_quest_var("%type%_wand", "wandtask1", 1)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end
if spell then
    local chance = 1 + bonus
    if random(1, 20) <= chance then
        spells.cast(self, "%spell% %victim%", level, self.level)
    end
end