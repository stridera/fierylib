-- Trigger: Beast Master Pumahl speech yes
-- Zone: 53, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--   Large script: 5785 chars
--
-- Original DG Script: #5312

-- Converted from DG Script #5312: Beast Master Pumahl speech yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(2)
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = person.group_member[a]
    if person.room == self.room then
        if not person:get_quest_stage("beast_master") then
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
                    if person:get_quest_stage("beast_master") == 1 then
                        local notice = 5300
                    elseif person:get_quest_stage("beast_master") == 2 then
                        local notice = 5301
                    elseif person:get_quest_stage("beast_master") == 3 then
                        local notice = 5302
                    elseif person:get_quest_stage("beast_master") == 4 then
                        local notice = 5303
                    elseif person:get_quest_stage("beast_master") == 5 then
                        local notice = 5304
                    elseif person:get_quest_stage("beast_master") == 6 then
                        local notice = 5305
                    elseif person:get_quest_stage("beast_master") == 7 then
                        local notice = 5306
                    elseif person:get_quest_stage("beast_master") == 8 then
                        local notice = 5307
                    elseif person:get_quest_stage("beast_master") == 9 then
                        local notice = 5308
                    elseif person:get_quest_stage("beast_master") == 10 then
                        local notice = 5309
                    end
                    self.room:spawn_object(vnum_to_zone(notice), vnum_to_local(notice))
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
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end  -- auto-close block