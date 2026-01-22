-- Trigger: phase wand status checker questmasters
-- Zone: 3, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 31 if statements
--   Large script: 11957 chars
--
-- Original DG Script: #314

-- Converted from DG Script #314: phase wand status checker questmasters
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: wand progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "wand") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
if actor.class ~= "sorcerer" and actor.class ~= "cryomancer" and actor.class ~= "pyromancer" and actor.class ~= "illusionist" and actor.class ~= "necromancer" then
    self:say("This weapon is only for students of the arcane arts.")
    return _return_value
end
local stage = actor.quest_stage[type_wand]
local job1 = actor.quest_variable[type_wand:wandtask1]
local job2 = actor.quest_variable[type_wand:wandtask2]
local job3 = actor.quest_variable[type_wand:wandtask3]
local job4 = actor.quest_variable[type_wand:wandtask4]
local job5 = actor.quest_variable[type_wand:wandtask5]
if actor.has_completed[type_wand] then
    self:say("It looks like you already have the most powerful staff of " .. tostring(type) .. " in existence!")
elseif stage == "wandstep" and actor.level >= (wandstep - 1) * 10 then
    if actor.quest_variable[type_wand:greet] == 0 then
        self:say("Tell me why you're here first.")
    else
        self:say("I'm improving your " .. tostring(type) .. " weapon.")
        if job1 or job2 or job3 or job4 then
            -- (empty room echo)
            self:say("You've done the following:")
            if job1 then
                self.room:send("- attacked " .. tostring(wandattack) .. " times")
            end
            if job2 then
                self.room:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
            end
            if job3 then
                if wandstep ~= 10 then
                    self.room:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                else
                    self.room:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                end
            end
            if job4 then
                if wandstep ~= 5 and wandstep ~= 9 and wandstep ~= 10 then
                    self.room:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                elseif wandstep == 5 then
                    self.room:send("- communed in " .. tostring(wandtask4))
                elseif wandstep == 9 then
                    self.room:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
                end
            end
        end
        -- (empty room echo)
        self.room:send("You need to:")
        if job1 and job2 and job3 and job4 then
            if wandstep ~= 6 and wandstep ~= 8 and wandstep ~= 10 then
                self.room:send("Just give me your " .. tostring(weapon) .. ".")
            elseif wandstep == 6 then
                if not job5 then
                    self.room:send("Just give me your " .. tostring(weapon) .. ".")
                else
                    self.room:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                end
            elseif wandstep == 8 then
                if not job5 then
                    self.room:send("Just give me your " .. tostring(weapon) .. ".")
                else
                    local room = get.room[place]
                    self.room:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                end
            elseif wandstep == 10 then
                local room = get.room[wandtask4]
                self.room:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
            end
        end
        if not job1 then
            local counter = 50
            local remaining = ((actor.quest_stage[type_wand] - 1) * counter) - actor.quest_variable[type_wand:attack_counter]
            self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
        end
        if not job2 then
            self.room:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
        end
        if not job3 then
            if wandstep ~= 10 then
                self.room:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                if wandstep == 4 then
                    self.room:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                    if self.id == 58601 then
                        self.room:send("</>    Search the far eastern edge of the continent.")
                    elseif self.id == 10306 then
                        self.room:send("</>    Search the south point beyond Anlun Vale.")
                    elseif self.id == 2337 then
                        self.room:send("</>    Search the surrounding forest.")
                    elseif self.id == 62504 then
                        self.room:send("</>    Search in the heart of the heart of the thorns.")
                    end
                    self.room:send("</>    The phrase to call the blessing is:")
                    self.room:send("</>    <b:cyan>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                end
            else
                self.room:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
            end
        end
        if not job4 then
            if wandstep ~= 3 and wandstep ~= 5 and wandstep ~= 9 and wandstep ~= 10 then
                self.room:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
            elseif wandstep == 5 then
                if type == "air" then
                    self.room:send("- <b:yellow>imbue your " .. tostring(weapon) .. " on " .. tostring(wandtask4) .. "</>")
                else
                    self.room:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                end
            elseif wandstep == 9 then
                self.room:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
            elseif wandstep == 10 then
                if job1 and job2 and job3 then
                    self.room:send("Just give me your " .. tostring(weapon) .. ".")
                end
            end
        end
    end
elseif stage > wandstep then
    self:say("I can't help you anymore, but I know who can.")
    if type == "air" then
        -- (empty room echo)
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
    elseif type == "fire" then
        -- (empty room echo)
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
    elseif type == "ice" then
        -- (empty room echo)
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
    elseif type == "acid" then
        -- (empty room echo)
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
elseif stage < wandstep then
    self:say("You need to make more improvements to your " .. tostring(weapon) .. " before I can work with it.'")
elseif actor.level < (wandstep - 1) * 10 then
    self:say("Come back after you've gained some more experience.  I can help you then.")
end