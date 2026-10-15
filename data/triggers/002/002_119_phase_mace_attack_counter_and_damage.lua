-- Trigger: Phase Mace attack counter and damage
-- Zone: 2, ID: 119
-- Type: OBJECT, Flags: ATTACK
--
-- Counts attacks toward the phase_mace bonding milestone (macetask1 at
-- stage * 50 hits) and, on roughly 75% of hits, casts a divine spell whose
-- power scales with mace stage:
--   - vs ethereal undead: divine bolt (340-345) or divine ray (346-349)
--   - vs other undead/demonic targets: divine bolt at half skill (343+)
-- The mace is the phase_mace quest's own weapon; its legacy vnum (340-349 = 2:140-2:149) picks the
-- spell tier. A bond flag that was reset to 0 counts as unset (dg.flag).
local dg = require("dg")
local vnum = dg.to_vnum(self.zone_id, self.id)
if actor:get_quest_stage("phase_mace") >= 1 then
    if not dg.flag(actor:get_quest_var("phase_mace:macetask1")) then
        local attack_increase = (actor:get_quest_var("phase_mace:attack_counter") or 0) + 1
        actor:set_quest_var("phase_mace", "attack_counter", attack_increase)
        if (actor:get_quest_var("phase_mace:attack_counter") or 0) >= actor:get_quest_stage("phase_mace") * 50 then
            actor:set_quest_var("phase_mace", "macetask1", 1)
            actor:send("<b:white>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end
if random(1, 4) > 1 then
    local skill = self.level
    local spell
    if victim.composition == "ether" and victim.lifeforce == "undead" then
        if vnum == 340 or vnum == 341 then
            return true
        elseif vnum == 342 or vnum == 343 or vnum == 344 or vnum == 345 then
            spell = "divine bolt"
        elseif vnum == 346 or vnum == 347 or vnum == 348 or vnum == 349 then
            spell = "divine ray"
        end
        if spell then
            spells.cast(self, spell, victim, skill)
        end
    elseif victim.lifeforce == "undead" or victim.lifeforce == "demonic" or victim.race == "demon" then
        skill = skill // 2
        if vnum == 340 or vnum == 341 or vnum == 342 then
            return true
        elseif vnum >= 343 and vnum <= 349 then
            spell = "divine bolt"
        end
        if spell then
            spells.cast(self, spell, victim, skill)
        end
    end
end
