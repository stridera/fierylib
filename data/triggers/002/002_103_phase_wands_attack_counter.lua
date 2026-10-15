-- Trigger: phase wands attack counter
-- Zone: 2, ID: 103
-- Type: OBJECT, Flags: ATTACK
--
-- Counts wielder attacks for the <type>_wand quest (50 per stage, stage 2 wants 50, stage 3 wants
-- 100, ...), then on each swing has a (1 + bonus)/20 chance of casting the wand's bound spell.
-- The wand's legacy vnum (300-339: 2:100-2:139) picks the element and the spell tier: the
-- xx1-xx5 wands cast a low-level spell, the xx6-xx9 staves a higher one at level - 50.
-- The wand is the <type>_wand quest's own weapon, so the quest name follows the element.
local dg = require("dg")

local vnum = dg.to_vnum(self.zone_id, self.id)
local element, spell, bonus, level
if vnum >= 300 and vnum <= 309 then
    element = "air"
    if vnum >= 301 and vnum <= 305 then
        spell = "shocking grasp"
        bonus = vnum - 301
        level = self.level
    else
        spell = "lightning bolt"
        bonus = vnum - 306
        level = self.level - 50
    end
elseif vnum >= 310 and vnum <= 319 then
    element = "fire"
    if vnum >= 311 and vnum <= 315 then
        spell = "burning hands"
        bonus = vnum - 311
        level = self.level
    else
        spell = "fireball"
        bonus = vnum - 316
        level = self.level - 50
    end
elseif vnum >= 320 and vnum <= 329 then
    element = "ice"
    if vnum >= 321 and vnum <= 325 then
        spell = "chill touch"
        bonus = vnum - 321
        level = self.level
    else
        spell = "cone of cold"
        bonus = vnum - 326
        level = self.level - 50
    end
elseif vnum >= 330 and vnum <= 339 then
    element = "acid"
    if vnum >= 331 and vnum <= 335 then
        spell = "writhing weeds"
        bonus = vnum - 331
        level = self.level
    else
        spell = "acid burst"
        bonus = vnum - 336
        level = self.level - 50
    end
end
if not element then return end

local quest = element .. "_wand"
local stage = actor:get_quest_stage(quest)
if stage > 1 then
    if not dg.flag(actor:get_quest_var(quest .. ":wandtask1")) then
        local attack_increase = (actor:get_quest_var(quest .. ":attack_counter") or 0) + 1
        actor:set_quest_var(quest, "attack_counter", attack_increase)
        if attack_increase >= (stage - 1) * 50 then
            actor:set_quest_var(quest, "wandtask1", 1)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end
if spell then
    local chance = 1 + bonus
    if random(1, 20) <= chance then
        spells.cast(self, spell, victim, level)
    end
end
