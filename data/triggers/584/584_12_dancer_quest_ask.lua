-- Trigger: Dancer_quest_ASK
-- Zone: 584, ID: 12
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #58412
--
-- Initial hook for the major_spell_quest (relocate quest). Only eligible to
-- level 65+ Sorcerer/Cryomancer/Pyromancer players who haven't started or
-- completed the quest yet; everyone else gets a grumble.

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

if not actor.is_player then
    return true
end
if actor.level < 65 then
    return true
end
-- Already past stage 0 means they've already started or finished it.
if (actor:get_quest_stage("major_spell_quest") or 0) >= 1 then
    return true
end
if actor:get_has_completed("major_spell_quest") then
    return true
end

local class = tostring(actor.class)
local eligible = string.find(class, "Sorcerer")
        or string.find(class, "Cryomancer")
        or string.find(class, "Pyromancer")

if eligible then
    wait(1)
    self:command("think")
    wait(1)
    actor:send(tostring(self.name) .. " says to you, 'I've been trapped here for so long.'")
    self:command("sigh")
    wait(1)
    actor:send(tostring(self.name) .. " says to you, 'The Prince has me enslaved against my will, will you help set me free?'")
    self:say("Yer a " .. class)
    actor:start_quest("major_spell_quest")
else
    self:command("grumble")
    self:say("Ok, I can talk, I swear " .. tostring(actor.name) .. " is a doofus.")
end