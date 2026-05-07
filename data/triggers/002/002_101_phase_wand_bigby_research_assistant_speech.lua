-- Trigger: phase wand bigby research assistant speech
-- Zone: 2, ID: 101
-- Type: MOB, Flags: SPEECH
--
-- Bigby's research assistant — central hub for the four wand quests
-- (air/fire/ice/acid). Reacts to element keywords by routing the player
-- into the matching <type>_wand quest:
--   - stage 1: tells them to bring the basic wand for blessing,
--   - stage 2: reminds them to keep practicing and bring the gem,
--   - stage > 2: gives the next breadcrumb based on the type of energy.
-- Generic "wand"/"upgrade" keywords without a type fall through to a
-- prompt asking for the element.
--
-- TODO(parity): The original DG used `%get.obj_shortdesc[%wandgem%]%` to
-- print the gem name; that interpolation is preserved in the message
-- strings below as a literal. Replace each occurrence with
-- `objects.template(z, id).name` once the wandgem id-table is wired up.
local lower = string.lower(speech or "")
local function has(word) return string.find(lower, word, 1, true) ~= nil end
if not (has("wand") or has("earth") or has("air") or has("fire") or has("water")
        or has("upgrade") or has("lightning") or has("wind") or has("shock")
        or has("electricity") or has("smoldering") or has("burning")
        or has("cold") or has("ice") or has("frost") or has("acid")
        or has("tremors") or has("corrosion") or has("powerful") or has("yes")) then
    return true
end
wait(2)
local class = actor.class or ""
if not (string.find(class, "sorcerer") or string.find(class, "pyromancer")
        or string.find(class, "cryomancer") or string.find(class, "illusionist")
        or string.find(class, "necromancer")) then
    self:say("I'm sorry, only true wizards can use these weapons.")
    return true
end
if actor.level < 10 then
    self:say("Come back after you've gained some more experience.  I can help you then.")
    return true
end

local quest_type, wandgem
if speech == "air" or speech == "lightning" or speech == "wind" or speech == "shock" or speech == "electricity" then
    quest_type, wandgem = "air", 55577
elseif speech == "fire" or speech == "smoldering" or speech == "burning" then
    quest_type, wandgem = "fire", 55575
elseif speech == "water" or speech == "cold" or speech == "ice" or speech == "frost" then
    quest_type, wandgem = "ice", 55574
elseif speech == "earth" or speech == "acid" or speech == "tremors" or speech == "corrosion" then
    quest_type, wandgem = "acid", 55576
end

if not quest_type then
    -- generic "wand"/"upgrade"/"yes" — prompt for element
    wait(2)
    -- Best-effort generic stage probe; uses any of the four quests'
    -- progression to gate the message (matches DG behavior of probing the
    -- nonexistent "type_wand" namespace).
    local stage = actor:get_quest_stage("air_wand")
        or actor:get_quest_stage("fire_wand")
        or actor:get_quest_stage("ice_wand")
        or actor:get_quest_stage("acid_wand")
        or 0
    if stage < 2 then
        self:say("Yeah, I can help you upgrade any basic wand!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Tell me what element you would like to improve.  You can say <green>acid</>, <b:yellow>air</>, <red>fire</>, or <b:blue>ice</>.'")
    elseif stage == 2 then
        self:say("Get some practice with the wand and bring me the gem I asked for.")
    else
        self.room:send(tostring(self.name) .. " says, 'I can't do anything more myself, but I can tell you where to go.  Tell me what element you would like to improve.  You can say <green>acid</>, <b:white>air</>, <red>fire</>, or <b:blue>ice</>.'")
    end
    return true
end

local quest = quest_type .. "_wand"
local stage = actor:get_quest_stage(quest)
wait(2)
if actor:get_has_completed(quest) then
    self.room:send(tostring(self.name) .. " says, 'It looks like you already have the most powerful weapon of " .. quest_type .. " in existence!'")
elseif not stage or stage == 1 then
    if not stage then
        actor:start_quest(quest)
    end
    self.room:send(tostring(self.name) .. " says, 'I can upgrade your " .. quest_type .. " wand!  But what I will do is just the first step in a life-long journey.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'This step is relatively simple.  You can check your <b:cyan>[wand progress]</> with me as well.'")
    wait(2)
    self:say("First, let me see your wand.")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'If you have the practice, give me the gem I described and your current wand.'")
elseif stage > 2 then
    if quest_type == "air" then
        self.room:send(tostring(self.name) .. " says, 'You'll be studying with a plethora of seers, mystics, and wisemen.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("Speak with the old Abbot in the Abbey of St. George.")
        elseif stage == 4 then self:say("The keeper of a southern coastal tower will have advice for you.")
        elseif stage == 5 then self:say("A master of air near the megalith in South Caelia will be able to help next.")
        elseif stage == 6 then self:say("Seek out the warrior-witch at the center of the southern megalith.")
        elseif stage == 7 then self:say("She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you.")
        elseif stage == 8 then self:say("In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work.")
        elseif stage == 9 then self:say("The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips.")
        elseif stage == 10 then self:say("Silania will help you craft the finest of air weapons.")
        end
    elseif quest_type == "fire" then
        self.room:send(tostring(self.name) .. " says, 'You should seek out the most renowned pyromancers in the world.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("The keeper of the temple to the dark flame out east will know what to do.")
        elseif stage == 4 then self:say("There's a fire master in the frozen north who likes to spend his time at the hot springs.")
        elseif stage == 5 then self:say("A master of fire near the megalith in South Caelia will be able to help next.")
        elseif stage == 6 then self:say("A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia.")
        elseif stage == 7 then self:say("I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though...")
        elseif stage == 8 then self:say("You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further.")
        elseif stage == 9 then self:say("Seek out the one who speaks for the Sun near Anduin.  He can upgrade your staff.")
        elseif stage == 10 then self:say("Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff.")
        end
    elseif quest_type == "ice" then
        self.room:send(tostring(self.name) .. " says, 'Masters of ice and water are highly varied in their professions.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.")
        elseif stage == 4 then self:say("Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale.")
        elseif stage == 5 then self:say("A master of spirits in the far north will be able to help next.")
        elseif stage == 6 then self:say("Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets.")
        elseif stage == 7 then self:say("You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite.")
        elseif stage == 8 then self:say("There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting.")
        elseif stage == 9 then self:say("The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him.")
        elseif stage == 10 then self:say("You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff.")
        end
    elseif quest_type == "acid" then
        self.room:send(tostring(self.name) .. " says, 'Acid is the energy of earth.  The master earth crafters all belong to the ranger network that safeguards places around Caelia.  You can check your <b:cyan>[wand progress]</> as you go.")
        wait(1)
        if stage == 3 then     self:say("First, seek the one who guards the eastern gates of Ickle.")
        elseif stage == 4 then self:say("The next two artisans dwell in the Rhell Forest south-east of Mielikki.")
        elseif stage == 5 then self:say("Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance.")
        elseif stage == 6 then self:say("The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay.")
        elseif stage == 7 then self:say("Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert.")
        elseif stage == 8 then self:say("Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you.")
        elseif stage == 9 then self:say("The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her.")
        elseif stage == 10 then self:say("Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff.")
        end
    end
end
return true
