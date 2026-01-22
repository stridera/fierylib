-- Trigger: phase wand bigby research assistant speech
-- Zone: 3, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--   Large script: 11116 chars
--
-- Original DG Script: #301

-- Converted from DG Script #301: phase wand bigby research assistant speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: wand earth air fire water upgrade lightning wind shock electricity smoldering burning cold ice frost acid tremors corrosion powerful yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "wand") or string.find(string.lower(speech), "earth") or string.find(string.lower(speech), "air") or string.find(string.lower(speech), "fire") or string.find(string.lower(speech), "water") or string.find(string.lower(speech), "upgrade") or string.find(string.lower(speech), "lightning") or string.find(string.lower(speech), "wind") or string.find(string.lower(speech), "shock") or string.find(string.lower(speech), "electricity") or string.find(string.lower(speech), "smoldering") or string.find(string.lower(speech), "burning") or string.find(string.lower(speech), "cold") or string.find(string.lower(speech), "ice") or string.find(string.lower(speech), "frost") or string.find(string.lower(speech), "acid") or string.find(string.lower(speech), "tremors") or string.find(string.lower(speech), "corrosion") or string.find(string.lower(speech), "powerful") or string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "sorcerer") or string.find(actor.class, "pyromancer") or string.find(actor.class, "cryomancer") or string.find(actor.class, "illusionist") or string.find(actor.class, "necromancer") then
    if actor.level >= 10 then
        -- switch on speech
        if speech == "air" or speech == "lightning" or speech == "wind" or speech == "shock" or speech == "electricity" then
            local type = "air"
            local wandgem = 55577
        elseif speech == "fire" or speech == "smoldering" or speech == "burning" then
            local type = "fire"
            local wandgem = 55575
        elseif speech == "water" or speech == "cold" or speech == "ice" or speech == "frost" then
            local type = "ice"
            local wandgem = 55574
        elseif speech == "earth" or speech == "acid" or speech == "tremors" or speech == "corrosion" then
            local type = "acid"
            local wandgem = 55576
        else
            wait(2)
            if actor.quest_stage[type_wand] < 2 then
                self:say("Yeah, I can help you upgrade any basic wand!")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'Tell me what element you would like to improve.  You can say <green>acid</>, <b:yellow>air</>, <red>fire</>, or <b:blue>ice</>.'")
            elseif actor.quest_stage[type_wand] == 2 then
                self:say("Get some practice with the wand and bring me " .. "%get.obj_shortdesc[%wandgem%]%.")
            elseif actor.quest_stage[type_wand] > 2 then
                self.room:send(tostring(self.name) .. " says, 'I can't do anything more myself, but I can tell you where to go.  Tell me what element you would like to improve.  You can say <green>acid</>, <b:white>air</>, <red>fire</>, or <b:blue>ice</>.'")
            end
            return _return_value
        end
        local stage = actor.quest_stage[type_wand]
        wait(2)
        if actor.has_completed[type_wand] then
            self.room:send(tostring(self.name) .. " says, 'It looks like you already have the most powerful weapon of " .. tostring(type) .. " in existence!'")
        elseif not stage or stage == 1 then
            if not actor.quest_stage[type_wand] then
                actor:start_quest("%type%_wand")
            end
            self.room:send(tostring(self.name) .. " says, 'I can upgrade your " .. tostring(type) .. " wand!  But what I will do is just the first step in a life-long journey.'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'This step is relatively simple.  You can check your <b:cyan>[wand progress]</> with me as well.'")
            wait(2)
            self:say("First, let me see your wand.")
        elseif stage == 2 then
            self.room:send(tostring(self.name) .. " says, 'If you have the practice, give me " .. "%get.obj_shortdesc[%wandgem%]% and your current wand.'")
        elseif stage > 2 then
            if type == "air" then
                self.room:send(tostring(self.name) .. " says, 'You'll be studying with a plethora of seers, mystics, and wisemen.  You can check your <b:cyan>[wand progress]</> as you go.'")
                wait(1)
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
                self.room:send(tostring(self.name) .. " says, 'You should seek out the most renowned pyromancers in the world.  You can check your <b:cyan>[wand progress]</> as you go.'")
                wait(1)
                if stage == 3 then
                    self:say("The keeper of the temple to the dark flame out east will know what to do.")
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
                self.room:send(tostring(self.name) .. " says, 'Masters of ice and water are highly varied in their professions.  You can check your <b:cyan>[wand progress]</> as you go.'")
                wait(1)
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
                self.room:send(tostring(self.name) .. " says, 'Acid is the energy of earth.  The master earth crafters all belong to the ranger network that safeguards places around Caelia.  You can check your <b:cyan>[wand progress]</> as you go.")
                wait(1)
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
    else
        self:say("Come back after you've gained some more experience.  I can help you then.")
    end
else
    self:say("I'm sorry, only true wizards can use these weapons.")
end