-- Trigger: Beast Master Pumahl speech yes
-- Zone: 53, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): broken: `local notice = N` is branch-scoped, used at
-- spawn_object on line 62. Group-iteration pattern (line 19-26) shadows
-- `a` inside if/else so the inner locals never escape - loop bound is
-- nil. Needs full rewrite from DG #5312.
--
-- Original DG Script: #5312

-- Converted from DG Script #5312: Beast Master Pumahl speech yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("beast_master") == 0 then
            person:start_quest("beast_master")
        end
        if person:get_has_completed("beast_master") then
            person:send(tostring(self.name) .. " says, 'You've already proven your dominion over the beasts of Ethilien!'")
        elseif person:get_quest_var("beast_master:hunt") == "dead" then
            person:send(tostring(self.name) .. " says, 'Give me your current assignment first.'")
        else
            if person.level >= (person:get_quest_stage("beast_master") - 1) * 10 then
                if person:get_quest_var("beast_master:hunt") ~= "running" then
                    person:send(tostring(self.name) .. " says, 'Excellent!'")
                    -- switch on person:get_quest_stage("beast_master")
                    local notice
                    if person:get_quest_stage("beast_master") == 1 then
                        notice = 0
                    elseif person:get_quest_stage("beast_master") == 2 then
                        notice = 1
                    elseif person:get_quest_stage("beast_master") == 3 then
                        notice = 2
                    elseif person:get_quest_stage("beast_master") == 4 then
                        notice = 3
                    elseif person:get_quest_stage("beast_master") == 5 then
                        notice = 4
                    elseif person:get_quest_stage("beast_master") == 6 then
                        notice = 5
                    elseif person:get_quest_stage("beast_master") == 7 then
                        notice = 6
                    elseif person:get_quest_stage("beast_master") == 8 then
                        notice = 7
                    elseif person:get_quest_stage("beast_master") == 9 then
                        notice = 8
                    elseif person:get_quest_stage("beast_master") == 10 then
                        notice = 9
                    end
                    self.room:spawn_object(53, notice)
                    self:command("give assignment " .. tostring(person))
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'When you've slayed the creature, bring that assignment back to me.  I'll reward you then.'")
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'Be brave, be strong, and good luck!'")
                    person:set_quest_var("beast_master", "hunt", "running")
                else
                    -- switch on person:get_quest_stage("beast_master")
                    if person:get_quest_stage("beast_master") == 1 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay an abominable slime creature in the sewers beneath Mielikki.'")
                    elseif person:get_quest_stage("beast_master") == 2 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Hunt down a large buck in the forests just outside of Mielikki.'")
                    elseif person:get_quest_stage("beast_master") == 3 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Track down the giant scorpion of Gothra.'")
                    elseif person:get_quest_stage("beast_master") == 4 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Head far to the south and kill a monstrous canopy spider.'")
                    elseif person:get_quest_stage("beast_master") == 5 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Behead the famed chimera of Fiery Island.'")
                    elseif person:get_quest_stage("beast_master") == 6 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay the \"king\" of the abominations known as driders.'")
                    elseif person:get_quest_stage("beast_master") == 7 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Close the eyes of a beholder from under Mt. Frostbite.'")
                    elseif person:get_quest_stage("beast_master") == 8 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Lay the Banshee to eternal rest.'")
                    elseif person:get_quest_stage("beast_master") == 9 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Put an end to Baba Yaga's dreamy witchcraft.'")
                    elseif person:get_quest_stage("beast_master") == 10 then
                        person:send(tostring(self.name) .. " says, 'You're still on the hunt.  Defeat the medusa below the city of Templace.'")
                    end
                end
            else
                person:send(tostring(self.name) .. " says, 'Unfortunately I don't have any beasts for you to pursue at the moment.  Check back later!'")
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end  -- auto-close block