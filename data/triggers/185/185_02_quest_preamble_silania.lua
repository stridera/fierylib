-- Trigger: quest_preamble_silania
-- Zone: 185, ID: 2
-- Type: MOB, Flags: SPEECH
--
-- When a Cleric or Warrior of an eligible race/level/alignment talks
-- about their "destiny" near Silania, she offers them the priest/paladin
-- subclass quest. Stores the chosen subclass in globals.use_subclass for
-- the follow-up yes/no trigger (185_03).

if not percent_chance(1) then
    return true
end

local s = string.lower(speech)
if not (string.find(s, "destiny") or string.find(s, "destinies") or string.find(s, "i know")) then
    return true
end

if actor:get_quest_stage("pri_pal_subclass") then
    return true
end

-- Level/race gating per class.
local classquest = false
if string.find(actor.class, "Cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to priest.</>")
            return true
        end
        classquest = true
    end
elseif string.find(actor.class, "Warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to paladin.</>")
            return true
        end
        classquest = true
    end
else
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you achieve your destiny.'")
    end
    return true
end

wait(2)

if not classquest then
    return true
end

if globals.use_subclass then
    actor:send(tostring(self.name) .. " says, 'I am currently helping another supplicant, one moment my child.'")
    return true
end

if actor.alignment <= 349 then
    actor:send(tostring(self.name) .. " says, 'I cannot help you if you are not good, little one.'")
    return true
end

if string.find(actor.class, "Warrior") and actor.level >= 10 and actor.level <= 25 then
    self:command("nod " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the holy warriors?'")
    globals.use_subclass = "Pal"
elseif string.find(actor.class, "Cleric") and actor.level >= 10 and actor.level <= 35 then
    self:command("nod " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the priests and help drive darkness from our world?'")
    globals.use_subclass = "Pri"
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'I appreciate your aspiring virtue.  Come and see me once you've gained more experience.'")
else
    actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
end
