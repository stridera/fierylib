-- Trigger: phase wands attack counter
-- Zone: 2, ID: 103
-- Type: OBJECT, Flags: ATTACK
--
-- Counts wielder attacks for the type_wand quest (50 hits per stage),
-- then on each swing has a (1 + bonus)/20 chance of casting the wand's
-- bound spell. The wand id range identifies which element and which tier
-- of spell to cast; the lower half (xx1-xx5) casts a low-level spell, the
-- upper half (xx6-xx9) casts a higher-tier one at level - 50.
--
-- TODO(parity): Uses the player's "type_wand" quest namespace (see other
-- phase wand triggers). The actual quest name is air_wand/fire_wand/
-- ice_wand/acid_wand; treat that namespace as a stand-in until the engine
-- exposes a typed quest binding.
local type, spell, bonus, level
if self.id >= 300 and self.id <= 309 then
    type = "air"
    if self.id >= 301 and self.id <= 305 then
        spell = "shocking grasp"
        bonus = self.id - 301
        level = self.level
    else
        spell = "lightning bolt"
        bonus = self.id - 306
        level = self.level - 50
    end
elseif self.id >= 310 and self.id <= 319 then
    type = "fire"
    if self.id >= 311 and self.id <= 315 then
        spell = "burning hands"
        bonus = self.id - 311
        level = self.level
    else
        spell = "fireball"
        bonus = self.id - 316
        level = self.level - 50
    end
elseif self.id >= 320 and self.id <= 329 then
    type = "ice"
    if self.id >= 321 and self.id <= 325 then
        spell = "chill touch"
        bonus = self.id - 321
        level = self.level
    else
        spell = "cone of cold"
        bonus = self.id - 326
        level = self.level - 50
    end
elseif self.id >= 330 and self.id <= 339 then
    type = "acid"
    if self.id >= 331 and self.id <= 335 then
        spell = "writhing weeds"
        bonus = self.id - 331
        level = self.level
    else
        spell = "acid burst"
        bonus = self.id - 336
        level = self.level - 50
    end
end
if (actor:get_quest_stage("type_wand") or 0) > 1 then
    if not actor:get_quest_var("type_wand:wandtask1") then
        local attack_increase = (actor:get_quest_var("type_wand:attack_counter") or 0) + 1
        actor:set_quest_var(tostring(type) .. "_wand", "attack_counter", attack_increase)
        if attack_increase >= (actor:get_quest_stage("type_wand") - 1) * 50 then
            actor:set_quest_var(tostring(type) .. "_wand", "wandtask1", 1)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end
if spell then
    local chance = 1 + (bonus or 0)
    if random(1, 20) <= chance then
        spells.cast(self, spell, victim, level)
    end
end
