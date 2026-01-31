-- Trigger: Honus speech yes
-- Zone: 53, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--   Large script: 6098 chars
--
-- Original DG Script: #5322

-- Converted from DG Script #5322: Honus speech yes
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
        if not person:get_quest_stage("treasure_hunter") then
            person:start_quest("treasure_hunter")
        end
        if person:get_has_completed("treasure_hunter") then
            person:send(tostring(self.name) .. " says, 'Only great treasures, the stuff of legend, still wait out there!'")
        elseif person:get_quest_var("treasure_hunter:hunt") == "found" then
            person:send(tostring(self.name) .. " says, 'Give me your current order first.'")
        else
            if person.level >= (person:get_quest_stage("treasure_hunter") - 1) * 10 then
                if person:get_quest_var("treasure_hunter:hunt") ~= "running" then
                    person:send(tostring(self.name) .. " says, 'Excellent!'")
                    -- switch on person:get_quest_stage("treasure_hunter")
                    if person:get_quest_stage("treasure_hunter") == 1 then
                        local order = 5310
                    elseif person:get_quest_stage("treasure_hunter") == 2 then
                        local order = 5311
                    elseif person:get_quest_stage("treasure_hunter") == 3 then
                        local order = 5312
                    elseif person:get_quest_stage("treasure_hunter") == 4 then
                        local order = 5313
                    elseif person:get_quest_stage("treasure_hunter") == 5 then
                        local order = 5314
                    elseif person:get_quest_stage("treasure_hunter") == 6 then
                        local order = 5315
                    elseif person:get_quest_stage("treasure_hunter") == 7 then
                        local order = 5316
                    elseif person:get_quest_stage("treasure_hunter") == 8 then
                        local order = 5317
                    elseif person:get_quest_stage("treasure_hunter") == 9 then
                        local order = 5318
                    elseif person:get_quest_stage("treasure_hunter") == 10 then
                        local order = 5319
                    end
                    local order_zone, order_local = order // 100, order % 100
                    self.room:spawn_object(order_zone, order_local)
                    self:command("give order " .. tostring(person))
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'When you've secured the goods, bring it and that order back to me.  I'll reward you then.  You can check your <b:cyan>[progress]</> at any time.'")
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'Have fun!'")
                    person:set_quest_var("treasure_hunter", "hunt", "running")
                else
                    -- switch on person:get_quest_stage("treasure_hunter")
                    if person:get_quest_stage("treasure_hunter") == 1 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find that singing chain and I'll pay you for your time.'")
                    elseif person:get_quest_stage("treasure_hunter") == 2 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find one of the true fire rings the theatre in Anduin gives out.  Not the fake prop ones most of the performers carry around, but the real ones they give out at their grand finale.'")
                    elseif person:get_quest_stage("treasure_hunter") == 3 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a sandstone ring in the caves to the west.'")
                    elseif person:get_quest_stage("treasure_hunter") == 4 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Recover the electrum hoop lost in the bayou shipwreck.'")
                    elseif person:get_quest_stage("treasure_hunter") == 5 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Bring me back a Rainbow Shell from the volcanic islands.'")
                    elseif person:get_quest_stage("treasure_hunter") == 6 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Raid Mystwatch and bring back the legendary Stormshield.'")
                    elseif person:get_quest_stage("treasure_hunter") == 7 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Get your hands on a Snow Leopard Cloak.'")
                    elseif person:get_quest_stage("treasure_hunter") == 8 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a magic ladder that uncoils itself.'")
                    elseif person:get_quest_stage("treasure_hunter") == 9 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Seek out a glowing phoenix feather.'")
                    elseif person:get_quest_stage("treasure_hunter") == 10 then
                        person:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Secure a piece of sleet armor.'")
                    end
                end
            else
                person:send(tostring(self.name) .. " says, 'There's still plenty of treasure out there, but it's too dangerous without more experience.  Come back when you've grown a little more.'")
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end  -- auto-close block