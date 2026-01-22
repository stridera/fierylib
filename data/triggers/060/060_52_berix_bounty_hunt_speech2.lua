-- Trigger: Berix bounty hunt speech2
-- Zone: 60, ID: 52
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--   Large script: 6004 chars
--
-- Original DG Script: #6052

-- Converted from DG Script #6052: Berix bounty hunt speech2
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
        if not person:get_quest_stage("bounty_hunt") then
            person:start_quest("bounty_hunt")
        end
        if person:get_has_completed("bounty_hunt") then
            person:send(tostring(self.name) .. " says, 'You know, I'm fresh out of work for you.  Good luck!'")
        elseif person:get_quest_var("bounty_hunt:bounty") == "dead" then
            person:send(tostring(self.name) .. " says, 'Give me your current contract first.'")
        else
            if person.level >= (person:get_quest_stage("bounty_hunt") - 1) * 10 then
                if person:get_quest_var("bounty_hunt:bounty") ~= "running" then
                    person:send(tostring(self.name) .. " says, 'Splendid.'")
                    -- switch on person:get_quest_stage("bounty_hunt")
                    if person:get_quest_stage("bounty_hunt") == 1 then
                        local contract = 6050
                    elseif person:get_quest_stage("bounty_hunt") == 2 then
                        local contract = 6051
                    elseif person:get_quest_stage("bounty_hunt") == 3 then
                        local contract = 6052
                    elseif person:get_quest_stage("bounty_hunt") == 4 then
                        local contract = 6053
                    elseif person:get_quest_stage("bounty_hunt") == 5 then
                        local contract = 6054
                    elseif person:get_quest_stage("bounty_hunt") == 6 then
                        local contract = 6055
                    elseif person:get_quest_stage("bounty_hunt") == 7 then
                        local contract = 6056
                    elseif person:get_quest_stage("bounty_hunt") == 8 then
                        local contract = 6057
                    elseif person:get_quest_stage("bounty_hunt") == 9 then
                        local contract = 6058
                    elseif person:get_quest_stage("bounty_hunt") == 10 then
                        local contract = 6059
                    else
                        local contract = 6050
                    end
                    self.room:spawn_object(vnum_to_zone(contract), vnum_to_local(contract))
                    self:command("give contract " .. tostring(person))
                    local accept = "yes"
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'When you've completed your task, bring that contract back to me.  I'll reward you then.'")
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'Keep a low profile and good luck.'")
                    person:set_quest_var("bounty_hunt", "bounty", "running")
                else
                    -- switch on person:get_quest_stage("bounty_hunt")
                    if person:get_quest_stage("bounty_hunt") == 1 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  Best get on killing that cat-king or whatever first.'")
                    elseif person:get_quest_stage("bounty_hunt") == 2 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the Noble and the Abbot  sheltering him at the Abbey of St. George.'")
                    elseif person:get_quest_stage("bounty_hunt") == 3 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the three Chieftains in the southwestern Highlands.'")
                    elseif person:get_quest_stage("bounty_hunt") == 4 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  Find the Frakati Leader and kill him.'")
                    elseif person:get_quest_stage("bounty_hunt") == 5 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  Infiltrate the Sacred Haven and take out the number two in command, Cyrus.'")
                    elseif person:get_quest_stage("bounty_hunt") == 6 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  Disappear Lord Venth down south.'")
                    elseif person:get_quest_stage("bounty_hunt") == 7 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  Send the high druid on a permanent pilgrimage.'")
                    elseif person:get_quest_stage("bounty_hunt") == 8 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  Kill the Lizard King.  If you can even find him...'")
                    elseif person:get_quest_stage("bounty_hunt") == 9 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the leader of the Ice Cult up north before they get wind of it.'")
                    elseif person:get_quest_stage("bounty_hunt") == 10 then
                        person:send(tostring(self.name) .. " says, 'You still have a job to do.  End the reign of the Goblin King.  We'll all probably dream a little more soundly then.'")
                    end
                end
            else
                person:send(tostring(self.name) .. " says, 'All my other jobs are too risky for someone without more experience.  Come back when you've seen a little more.'")
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end  -- auto-close block