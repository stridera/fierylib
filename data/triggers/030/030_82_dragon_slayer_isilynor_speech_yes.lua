-- Trigger: Dragon Slayer Isilynor Speech yes
-- Zone: 30, ID: 82
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3082

-- Converted from DG Script #3082: Dragon Slayer Isilynor Speech yes
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
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
    if person and person.room == self.room then
        if person:get_quest_stage("dragon_slayer") == 0 and person.level > 4 then
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
                    local notice
                    -- switch on person:get_quest_stage("dragon_slayer")
                    do
                        local _sw1 = string.lower(tostring(person:get_quest_stage("dragon_slayer") or ""))
                        if tonumber(_sw1) == 1 then
                            notice = 80
                        elseif tonumber(_sw1) == 2 then
                            notice = 81
                        elseif tonumber(_sw1) == 3 then
                            notice = 82
                        elseif tonumber(_sw1) == 4 then
                            notice = 83
                        elseif tonumber(_sw1) == 5 then
                            notice = 84
                        elseif tonumber(_sw1) == 6 then
                            notice = 85
                        elseif tonumber(_sw1) == 7 then
                            notice = 86
                        elseif tonumber(_sw1) == 8 then
                            notice = 87
                        elseif tonumber(_sw1) == 9 then
                            notice = 88
                        elseif tonumber(_sw1) == 10 then
                            notice = 89
                        end
                    end
                    self.room:spawn_object(30, notice)
                    self:command("give notice " .. tostring(person))
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'When you've slayed the beast, bring that notice back to me.  I'll reward you then.'")
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'Be brave, be strong, and good luck!'")
                    person:set_quest_var("dragon_slayer", "hunt", "running")
                else
                    -- switch on person:get_quest_stage("dragon_slayer")
                    do
                        local _sw2 = string.lower(tostring(person:get_quest_stage("dragon_slayer") or ""))
                        if tonumber(_sw2) == 1 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
                        elseif tonumber(_sw2) == 2 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
                        elseif tonumber(_sw2) == 3 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
                        elseif tonumber(_sw2) == 4 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
                        elseif tonumber(_sw2) == 5 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
                        elseif tonumber(_sw2) == 6 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
                        elseif tonumber(_sw2) == 7 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
                        elseif tonumber(_sw2) == 8 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
                        elseif tonumber(_sw2) == 9 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
                        elseif tonumber(_sw2) == 10 then
                            person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
                        end
                    end
                end
            else
                person:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end