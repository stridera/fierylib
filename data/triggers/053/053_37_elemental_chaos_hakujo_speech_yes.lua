-- Trigger: Elemental Chaos Hakujo speech yes
-- Zone: 53, ID: 37
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 6326 chars
--
-- Original DG Script: #5337

-- Converted from DG Script #5337: Elemental Chaos Hakujo speech yes
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
        if not person:get_quest_stage("elemental_chaos") then
            person:start_quest("elemental_chaos")
        end
        if person:get_has_completed("elemental_chaos") then
            person:send(tostring(self.name) .. " says, 'Chaos can never be truly destroyed, but you have helped restore Balance.'")
        elseif person:get_quest_var("elemental_chaos:bounty") == "dead" then
            person:send(tostring(self.name) .. " says, 'Give me your current mission first.'")
        else
            if person.level >= (person:get_quest_stage("elemental_chaos") - 1) * 10 then
                if person:get_quest_var("elemental_chaos:bounty") ~= "running" then
                    person:send(tostring(self.name) .. " says, 'Splendid.'")
                    -- switch on person:get_quest_stage("elemental_chaos")
                    if person:get_quest_stage("elemental_chaos") == 1 then
                        local mission = 5320
                    elseif person:get_quest_stage("elemental_chaos") == 2 then
                        local mission = 5321
                    elseif person:get_quest_stage("elemental_chaos") == 3 then
                        local mission = 5322
                    elseif person:get_quest_stage("elemental_chaos") == 4 then
                        local mission = 5323
                    elseif person:get_quest_stage("elemental_chaos") == 5 then
                        local mission = 5324
                    elseif person:get_quest_stage("elemental_chaos") == 6 then
                        local mission = 5325
                    elseif person:get_quest_stage("elemental_chaos") == 7 then
                        local mission = 5326
                    elseif person:get_quest_stage("elemental_chaos") == 8 then
                        local mission = 5327
                    elseif person:get_quest_stage("elemental_chaos") == 9 then
                        local mission = 5328
                    elseif person:get_quest_stage("elemental_chaos") == 10 then
                        local mission = 5329
                    else
                        local mission = 5320
                    end
                    self.room:spawn_object(vnum_to_zone(mission), vnum_to_local(mission))
                    self:command("give mission " .. tostring(person))
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'When you've completed your task, bring that mission back to me.  I can give you a modest reward.  You can check your <b:cyan>[progress]</> at any time.'")
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'Walk the Way.'")
                    self:command("bow")
                    person:set_quest_var("elemental_chaos", "bounty", "running")
                elseif person:get_quest_var("elemental_chaos:bounty") ~= "running" then
                    -- switch on person:get_quest_stage("elemental_chaos")
                    if person:get_quest_stage("elemental_chaos") == 1 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Investigate the news of an imp and dispatch it if you find one.'")
                    elseif person:get_quest_stage("elemental_chaos") == 2 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Silence the seductive song of the Leading Player.'")
                    elseif person:get_quest_stage("elemental_chaos") == 3 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy the Chaos and the cult worshipping it!'")
                    elseif person:get_quest_stage("elemental_chaos") == 4 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Undertake the vision quest from the shaman in Three-Falls Canyon and defeat whatever awaits at the end.'")
                    elseif person:get_quest_stage("elemental_chaos") == 5 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Dispatch the Fangs of Yeenoghu.  Be sure to destroy all of them.'")
                    elseif person:get_quest_stage("elemental_chaos") == 6 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Extinguish the fire elemental lord who serves Krisenna.'")
                    elseif person:get_quest_stage("elemental_chaos") == 7 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Stop the acolytes in the Cathedral of Betrayal.'")
                    elseif person:get_quest_stage("elemental_chaos") == 8 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy Cyprianum the Reaper in the heart of his maze.'")
                    elseif person:get_quest_stage("elemental_chaos") == 9 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Banish the Chaos Demon in Frost Valley.'")
                    elseif person:get_quest_stage("elemental_chaos") == 10 then
                        person:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Slay one of the Norhamen.'")
                    end
                end
            else
                person:send(tostring(self.name) .. " says, 'Give me more time to strategize how to bring Balance to Chaos.  Come back after you've gained some more experience.'")
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end  -- auto-close block