-- Trigger: smart combat
-- Zone: 188, ID: 70
-- Type: MOB, Flags: FIGHT
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 8449 chars
--
-- Original DG Script: #18870

-- Converted from DG Script #18870: smart combat
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local now = ((((time.year * 16) + time.month) * 35) + time.day) * 24) + time.hour
local level = self.level
local class = self.class
local flags = self.flags
local is_sor = class == Sorcerer
local is_cry = class == Cryomancer
local is_pyr = class == Pyromancer
local is_nec = class == Necromancer
local is_arc = is_sor  or  is_cry  or  is_pyr  or  is_nec
local is_war = class == Warrior
local is_ran = class == Ranger
local is_pal = class == Paladin
local is_ant = class /= Anti
local is_mon = class == Monk
local is_com = is_ran  or  is_pal  or  is_ant
local is_fig = is_war  or  is_mon  or  is_com
local is_rog = class == Rogue
local is_thi = class == Thief
local is_ass = class == Assassin
local is_mer = class == Mercenary
local is_bac = is_rog  or  is_thi  or  is_ass  or  is_mer
local is_cle = class == Cleric
local is_pri = class == Priest
local is_dia = class == Diabolist
local is_dru = class == Druid
local is_div = is_cle  or  is_pri  or  is_dia  or  is_dru
local is_mag = is_arc  or  is_div  or  is_com
local cir_2 = level >= 9
local cir_3 = level >= 17
local cir_4 = level >= 25
local cir_5 = level >= 33
local cir_6 = level >= 41
local cir_7 = level >= 49
local cir_8 = level >= 57
local cir_9 = level >= 65
local cir_10 = level >= 73
local cir_11 = level >= 81
local cir_12 = level >= 89
local cir_13 = level >= 97
wait(1)
local mode = random(1, 10)
-- Do fighter/rogue type stuff
if is_fig or is_bac then
    if (mode < 4) and ((is_ran and (level > 34)) or (is_war and (level > 14)) or ((is_ant or is_pal) and (level > 9))) then
        local max_tries = 5
        while %max_tries > 0 do
            local victim = room.actors[random(1, #room.actors)]
            if (victim.id ~= -1) and (victim.class ~= "Warrior") and (victim.class ~= "Ranger") and (not (string.find(victim.class, "Anti"))) and (victim.class ~= "Paladin") and (victim.class ~= "Monk") then
                combat.rescue(self, victim.name)
                local attempted = 1
            end
            local max_tries = max_tries - 1
        end
        if attempted then
            return _return_value
        end
    end
    if (is_war or is_ran or is_pal or is_ant or is_mer) and (level - actor.level >= 0) and (self:get_worn("11") ~= -1) then
        skills.execute(self, "bash", self.fighting)
    elseif (is_ass or is_thi or (is_rog and (level > 9)) or (is_mer and (level > 10))) and (self:get_worn("16") ~= -1) then
        skills.execute(self, "backstab", self.fighting)
    elseif (is_war and (level > 49)) or ((is_pal or is_ant) and (level > 79)) then
        self:attack_all()
    elseif ((is_war or is_ran or is_pal or is_ant or is_mon or is_mer) and (level >= 1)) or (is_ass and (level >= 36)) then
        skills.execute(self, "kick", self.fighting)
    end
    return _return_value
end
-- Initalize chance to do support spells
if not defensive then
    local defensive = 5
    globals.defensive = globals.defensive or true
end
-- Attempt to cast support spells
if mode <= defensive then
    if ((is_nec and cir_7) or (is_arc and (not is_nec) and cir_6)) and (not (flags% /= HASTE)) then
        spells.cast(self, "haste")
    elseif ((is_nec and cir_12) or (is_arc and (not is_nec) and cir_6)) and (not (flags% /= STONE)) then
        spells.cast(self, "stone skin")
    elseif ((is_ran and cir_3) or is_dru) and (barkskin + 6 + (level / 10) < now) then
        spells.cast(self, "barkskin")
        local barkskin = now
        globals.barkskin = globals.barkskin or true
    elseif (is_cle or (is_pal and cir_2) or is_pri) and (armor + 10 < now) then
        spells.cast(self, "armor")
        local armor = now
        globals.armor = globals.armor or true
    elseif (is_dia or (is_ant and cir_2)) and (demonskin + 10 + (level / 40) < now) then
        spells.cast(self, "demonskin")
        local demonskin = now
        globals.demonskin = globals.demonskin or true
    elseif is_dia and cir_4 and (demonic + 11 < now) then
        spells.cast(self, "demonic aspect")
        local demonic = now
        globals.demonic = globals.demonic or true
    elseif is_pyr and cir_4 and (mirage + 10 < now%) then
        spells.cast(self, "mirage")
        local mirage = now
        globals.mirage = globals.mirage or true
    else
        local mode = 6
    end
end
if mode > 5 then
    if (is_sor or is_cry) and cir_8 then
        spells.cast(self, "chain lightning")
    elseif is_pyr and cir_6 then
        spells.cast(self, "firestorm")
    elseif (is_sor or is_cry) and cir_6 then
        spells.cast(self, "ice storm")
    elseif (self.alignment > 350) and ((is_cle and cir_6) or (is_pri and cir_9) or (is_pal and cir_10)) then
        spells.cast(self, "holy word")
    elseif (self.alignment < -350) and ((is_cle and cir_6) or (is_dia and cir_9) or (is_ant and cir_11)) then
        spells.cast(self, "unholy word")
    elseif is_sor and cir_9 and mode <= 2 then
        spells.cast(self, "disintegrate")
        -- elseif %is_cry% && %cir_9%
        -- cast 'iceball'
        -- elseif %is_pyr% && %cir_9%
        -- cast 'immolate'
    elseif is_dru and cir_9 and ((not (string.find(actor.flags, "BLIND"))) or not outside) then
        spells.cast(self, "sunray")
    elseif is_sor and cir_7 then
        spells.cast(self, "bigbys clenched fist")
    elseif outside and is_dru and cir_7 then
        spells.cast(self, "call lightning")
    elseif (is_cle and cir_7) or ((is_pri or is_dia) and cir_10) then
        spells.cast(self, "full harm")
    elseif is_arc and (not is_nec) and cir_4 and (not (string.find(actor.flags, "ENFEEB"))) then
        spells.cast(self, "ray of enfeeblement")
    elseif outdoors and ((is_dru and cir_4) or (is_div and (not is_dru) and cir_5)) then
        spells.cast(self, "earthquake")
    elseif is_pyr and cir_7 and mode <= 2 then
        spells.cast(self, "melt")
    elseif is_dia and cir_7 and (not (string.find(actor.flags, "INSANITY"))) then
        spells.cast(self, "insanity")
    elseif is_pri and cir_6 and (actor.alignment < 350) then
        spells.cast(self, "divine ray")
    elseif is_dia and cir_6 then
        spells.cast(self, "stygian eruption")
    elseif is_nec and cir_5 then
        spells.cast(self, "energy drain")
    elseif (is_sor or is_cry) and cir_5 then
        spells.cast(self, "cone of cold")
    elseif (is_cle or is_dru) and cir_5% then
        spells.cast(self, "harm")
    elseif is_pyr and cir_5 then
        spells.cast(self, "heatwave")
    elseif (is_cle or is_pri) and cir_4 and (actor.alignment <= 350) then
        spells.cast(self, "dispel evil")
    elseif (is_cle or is_dia) and cir_4 and (actor.alignment >= 350) then
        spells.cast(self, "dispel good")
    elseif ((is_div and (not is_dru) and cir_4) or (is_ant and cir_6)) and (not (string.find(actor.flags, "BLIND"))) then
        spells.cast(self, "blindness")
    elseif (is_sor and cir_6) or (is_pyr and cir_4) then
        spells.cast(self, "fireball")
    elseif is_cle and cir_4 and (self.alignment >= 350) then
        spells.cast(self, "flamestrike")
    elseif (is_arc and (not is_pyr) and cir_4) or (is_dru and cir_6) then
        spells.cast(self, "lightning bolt")
    elseif is_pri and cir_3 and (self.alignment >= 350) and (actor.alignment < 350) then
        spells.cast(self, "divine bolt")
    elseif is_dia and cir_3 and (actor.alignment > 350) then
        spells.cast(self, "hell bolt")
    elseif is_div and (not is_dru) and cir_3 then
        spells.cast(self, "cause critical")
    elseif is_arc and (not is_pyr) and cir_3 then
        spells.cast(self, "shocking grasp")
    elseif is_pyr and cir_3 and (not (string.find(actor.flags, "BLIND"))) then
        spells.cast(self, "smoke")
    elseif is_dru and cir_3 then
        spells.cast(self, "writhing weeds")
    elseif is_div and (not is_dru) and cir_2 then
        spells.cast(self, "cause serious")
    elseif is_arc and (not is_pyr) and cir_2 then
        spells.cast(self, "chill touch")
    elseif is_pyr and cir_2 then
        spells.cast(self, "fire darts")
    elseif is_pyr then
        spells.cast(self, "burning hands")
    elseif is_cry then
        spells.cast(self, "ice darts")
    elseif is_arc then
        spells.cast(self, "magic missile")
    elseif is_div and not is_dru then
        spells.cast(self, "cause light")
    end
end
local action = now
globals.action = globals.action or true