-- Trigger: phase wand bigby research assistant progress checker
-- Zone: 3, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 41 if statements
--   Large script: 14439 chars
--
-- Original DG Script: #313

-- Converted from DG Script #313: phase wand bigby research assistant progress checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress progress? status status?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?") or string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?")) then
    return true  -- No matching keywords
end
wait(2)
local weapon = "wand"
local times = 50
if actor:get_quest_stage("air_wand") then
    self.room:send("<b:yellow>AIR</>")
    if actor:get_has_completed("air_wand") then
        self:say("It looks like you already have the most powerful staff of air in existence!")
    elseif actor:get_quest_stage("air_wand") == 1 then
        self:say("Let me see " .. tostring(objects.template(3, 0).name) .. ".")
    elseif actor:get_quest_stage("air_wand") == 2 then
        self:say("I am crafting a new air wand for you.")
        if actor:get_quest_var("air_wand:wandtask1") and actor:get_quest_var("air_wand:wandtask2") then
            -- (empty room echo)
            self.room:send("Simply give me your " .. get_obj_noadesc("300") .. ".")
        else
            if actor:get_quest_var("air_wand:wandtask1") or actor:get_quest_var("air_wand:wandtask2") then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if actor:get_quest_var("air_wand:wandtask1") then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if actor:get_quest_var("air_wand:wandtask2") then
                    self.room:send("- brought " .. tostring(objects.template(555, 77).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not actor:get_quest_var("air_wand:wandtask1") then
                local remaining = times - actor:get_quest_var("air_wand:attack_counter")
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not actor:get_quest_var("air_wand:wandtask2") then
                self.room:send("- <b:yellow>bring me " .. tostring(objects.template(555, 77).name) .. "</>")
            end
        end
    else
        if actor:get_quest_stage("air_wand") > 2 then
            self:say("I can't help you with air anymore, but I know who can.")
            -- (empty room echo)
            local stage = actor:get_quest_stage("air_wand")
            if stage == 3 then
                self:say("Speak with the old Abbot in the Abbey of St. George.")
            elseif stage == 4 then
                self:say("The keeper of a southern coastal tower will have advice for you.")
            elseif stage == 5 then
                self:say("A master of air near the megalith in South Caelia will be able to help next.")
            elseif stage == 6 then
                self:say("Seek out the warrior-witch at the center of the southern megalith.")
            elseif stage == 7 then
                self:say("She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you.")
            elseif stage == 8 then
                self:say("In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work.")
            elseif stage == 9 then
                self:say("The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips.")
            elseif stage == 10 then
                self:say("Silania will help you craft the finest of air weapons.")
            end
        end
    end
    -- (empty send to actor)
end
if actor:get_quest_stage("fire_wand") then
    self.room:send("<red>FIRE</>")
    if actor:get_has_completed("fire_wand") then
        self:say("It looks like you already have the most powerful staff of fire in existence!")
    elseif actor:get_quest_stage("fire_wand") == 1 then
        self:say("Let me see " .. tostring(objects.template(3, 10).name) .. ".")
    elseif actor:get_quest_stage("fire_wand") == 2 then
        self:say("I am crafting a new fire wand for you.")
        if actor:get_quest_var("fire_wand:wandtask1") and actor:get_quest_var("fire_wand:wandtask2") then
            -- (empty room echo)
            self.room:send("Simply give me your " .. get_obj_noadesc("310") .. ".")
        else
            if actor:get_quest_var("fire_wand:wandtask1") or actor:get_quest_var("fire_wand:wandtask2") then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if actor:get_quest_var("fire_wand:wandtask1") then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if actor:get_quest_var("fire_wand:wandtask2") then
                    self.room:send("- brought " .. tostring(objects.template(555, 75).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not actor:get_quest_var("fire_wand:wandtask1") then
                local remaining = times - actor:get_quest_var("fire_wand:attack_counter")
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not actor:get_quest_var("fire_wand:wandtask2") then
                self.room:send("- <b:yellow>bring me " .. tostring(objects.template(555, 75).name) .. "</>")
            end
        end
    else
        if actor:get_quest_stage("fire_wand") > 2 then
            self:say("I can't help you with fire anymore, but I know who can.")
            -- (empty room echo)
            local stage = actor:get_quest_stage("fire_wand")
            if stage == 3 then
                self:say("A minion of the dark flame out east will know what to do.")
            elseif stage == 4 then
                self:say("There's a fire master in the frozen north who likes to spend his time at the hot springs.")
            elseif stage == 5 then
                self:say("A master of fire near the megalith in South Caelia will be able to help next.")
            elseif stage == 6 then
                self:say("A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia.")
            elseif stage == 7 then
                self:say("I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though...")
            elseif stage == 8 then
                self:say("You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further.")
            elseif stage == 9 then
                self:say("Seek out the one who speaks for the Sun near Anduin.  He can upgrade your staff.")
            elseif stage == 10 then
                self:say("Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff.")
            end
        end
    end
    -- (empty send to actor)
end
if actor:get_quest_stage("ice_wand") then
    self.room:send("<b:cyan>ICE</>")
    if actor:get_has_completed("ice_wand") then
        self:say("It looks like you already have the most powerful staff of ice in existence!")
    elseif actor:get_quest_stage("ice_wand") == 1 then
        self:say("Let me see " .. tostring(objects.template(3, 20).name) .. ".")
    elseif actor:get_quest_stage("ice_wand") == 2 then
        self:say("I am crafting a new ice wand for you.")
        if actor:get_quest_var("ice_wand:wandtask1") and actor:get_quest_var("ice_wand:wandtask2") then
            -- (empty room echo)
            self.room:send("Simply give me your " .. get_obj_noadesc("320") .. ".")
        else
            if actor:get_quest_var("ice_wand:wandtask1") or actor:get_quest_var("ice_wand:wandtask2") then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if actor:get_quest_var("ice_wand:wandtask1") then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if actor:get_quest_var("ice_wand:wandtask2") then
                    self.room:send("- brought " .. tostring(objects.template(555, 74).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not actor:get_quest_var("ice_wand:wandtask1") then
                local remaining = times - actor:get_quest_var("ice_wand:attack_counter")
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not actor:get_quest_var("ice_wand:wandtask2") then
                self.room:send("- <b:yellow>bring me " .. tostring(objects.template(555, 74).name) .. "</>")
            end
        end
    else
        if actor:get_quest_stage("ice_wand") > 2 then
            self:say("I can't help you with ice anymore, but I know who can.")
            -- (empty room echo)
            local stage = actor:get_quest_stage("ice_wand")
            if stage == 3 then
                self:say("The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.")
            elseif stage == 4 then
                self:say("Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale.")
            elseif stage == 5 then
                self:say("A master of spirits in the far north will be able to help next.")
            elseif stage == 6 then
                self:say("Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets.")
            elseif stage == 7 then
                self:say("You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite.")
            elseif stage == 8 then
                self:say("There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting.")
            elseif stage == 9 then
                self:say("The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him.")
            elseif stage == 10 then
                self:say("You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff.")
            end
        end
    end
    -- (empty send to actor)
end
if actor:get_quest_stage("acid_wand") then
    self.room:send("<b:green>ACID</>")
    if actor:get_has_completed("acid_wand") then
        self:say("It looks like you already have the most powerful staff of acid in existence!")
    elseif actor:get_quest_stage("acid_wand") == 1 then
        self:say("Let me see " .. tostring(objects.template(3, 30).name) .. ".")
    elseif actor:get_quest_stage("acid_wand") == 2 then
        self:say("I am crafting a new acid wand for you.")
        if actor:get_quest_var("acid_wand:wandtask1") and actor:get_quest_var("acid_wand:wandtask2") then
            -- (empty room echo)
            self.room:send("Simply give me your " .. get_obj_noadesc("330") .. ".")
        else
            if actor:get_quest_var("acid_wand:wandtask1") or actor:get_quest_var("acid_wand:wandtask2") then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if actor:get_quest_var("acid_wand:wandtask1") then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if actor:get_quest_var("acid_wand:wandtask2") then
                    self.room:send("- brought " .. tostring(objects.template(555, 76).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not actor:get_quest_var("acid_wand:wandtask1") then
                local remaining = times - actor:get_quest_var("acid_wand:attack_counter")
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not actor:get_quest_var("acid_wand:wandtask2") then
                self.room:send("- <b:yellow>bring me " .. tostring(objects.template(555, 76).name) .. "</>")
            end
        end
    else
        if actor:get_quest_stage("acid_wand") > 2 then
            self:say("I can't help you with acid anymore, but I know who can.")
            -- (empty room echo)
            local stage = actor:get_quest_stage("acid_wand")
            if stage == 3 then
                self:say("First, seek the one who guards the eastern gates of Ickle.")
            elseif stage == 4 then
                self:say("The next two artisans dwell in the Rhell Forest south-east of Mielikki.")
            elseif stage == 5 then
                self:say("Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance.")
            elseif stage == 6 then
                self:say("The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay.")
            elseif stage == 7 then
                self:say("Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert.")
            elseif stage == 8 then
                self:say("Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you.")
            elseif stage == 9 then
                self:say("The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her.")
            elseif stage == 10 then
                self:say("Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff.")
            end
        end
    end
end