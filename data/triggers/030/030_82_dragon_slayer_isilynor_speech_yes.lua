-- Trigger: Dragon Slayer Isilynor Speech yes
-- Zone: 30, ID: 82
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 6184 chars
--
-- Original DG Script: #3082

-- Converted from DG Script #3082: Dragon Slayer Isilynor Speech yes
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

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
        if not person:get_quest_stage("dragon_slayer") and person.level > 4 then
            person:start_quest("dragon_slayer")
        end
        if person:get_has_completed("dragon_slayer") then
            person:send(tostring(self.name) .. " says, 'The only dragons remaining are beasts of legend!'")
        elseif person.level < 5 then
            person:send(tostring(self.name) .. " says, 'You're not quite ready to start taking on dragons.  Come back when you've seen a little more.'")
        elseif person:get_quest_var("dragon_slayer:hunt") == "dead" then
            person:send(tostring(self.name) .. " says, 'Give me your current notice first.'")
        else
            if person.level >= (person:get_quest_stage("dragon_slayer") - 1) * 10 then
                if person:get_quest_var("dragon_slayer:hunt") ~= "running" then
                    person:send(tostring(self.name) .. " says, 'Excellent!'")
                    -- switch on person:get_quest_stage("dragon_slayer")
                    if person:get_quest_stage("dragon_slayer") == 1 then
                        local notice = 3080
                    elseif person:get_quest_stage("dragon_slayer") == 2 then
                        local notice = 3081
                    elseif person:get_quest_stage("dragon_slayer") == 3 then
                        local notice = 3082
                    elseif person:get_quest_stage("dragon_slayer") == 4 then
                        local notice = 3083
                    elseif person:get_quest_stage("dragon_slayer") == 5 then
                        local notice = 3084
                    elseif person:get_quest_stage("dragon_slayer") == 6 then
                        local notice = 3085
                    elseif person:get_quest_stage("dragon_slayer") == 7 then
                        local notice = 3086
                    elseif person:get_quest_stage("dragon_slayer") == 8 then
                        local notice = 3087
                    elseif person:get_quest_stage("dragon_slayer") == 9 then
                        local notice = 3088
                    elseif person:get_quest_stage("dragon_slayer") == 10 then
                        local notice = 3089
                    end
                    self.room:spawn_object(vnum_to_zone(notice), vnum_to_local(notice))
                    self:command("give notice " .. tostring(person))
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'When you've slayed the beast, bring that notice back to me.  I'll reward you then.'")
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'Be brave, be strong, and good luck!'")
                    person:set_quest_var("dragon_slayer", "hunt", "running")
                else
                    -- switch on person:get_quest_stage("dragon_slayer")
                    if person:get_quest_stage("dragon_slayer") == 1 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
                    elseif person:get_quest_stage("dragon_slayer") == 2 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
                    elseif person:get_quest_stage("dragon_slayer") == 3 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
                    elseif person:get_quest_stage("dragon_slayer") == 4 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
                    elseif person:get_quest_stage("dragon_slayer") == 5 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
                    elseif person:get_quest_stage("dragon_slayer") == 6 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
                    elseif person:get_quest_stage("dragon_slayer") == 7 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
                    elseif person:get_quest_stage("dragon_slayer") == 8 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
                    elseif person:get_quest_stage("dragon_slayer") == 9 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
                    elseif person:get_quest_stage("dragon_slayer") == 10 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
                    end
                end
            else
                person:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end  -- auto-close block