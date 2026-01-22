-- Trigger: Dancer_quest_ASK
-- Zone: 584, ID: 12
-- Type: MOB, Flags: SPEECH_TO
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #58412

-- Converted from DG Script #58412: Dancer_quest_ASK
-- Original: MOB trigger, flags: SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
-- This is the initial quest start to the
-- relocate quest, other quests can be added
-- here with some work but this is going to
-- be geared to the classes that get relocate
self.room:send("DEBUG: Trigger running for " .. tostring(actor.name) .. " of class (" .. tostring(actor.class) .. ")")
-- for the time being
if actor.id == -1 then
    if actor.level >= 65 then
        if actor:get_quest_stage("major_spell_quest") < 1 then
            if actor:get_has_completed("major_spell_quest") ~= false then
                local gogogo = 0
                if string.find(actor.class, "Sorcerer") then
                    local gogogo = 1
                end
                if string.find(actor.class, "Cryomancer") then
                    local gogogo = 1
                end
                if string.find(actor.class, "Pyromancer") then
                    local gogogo = 1
                end
                if gogogo == 1 then
                    wait(1)
                    self:command("think")
                    wait(1)
                    actor:send(tostring(self.name) .. " says to you, 'I've been trapped here for so long.'")
                    self:command("sigh")
                    wait(1)
                    actor:send(tostring(self.name) .. " says to you, 'The Prince has me enslaved against my will, will you help set me free?'")
                    self:say("Yer a " .. tostring(actor.class))
                    actor.name:start_quest("major_spell_quest")
                else
                    self:command("grumble")
                    self:say("Ok, I can talk, I swear " .. tostring(actor.name) .. " is a doofus.")
                end
            else
            end
        else
        end
    else
    end
else
end