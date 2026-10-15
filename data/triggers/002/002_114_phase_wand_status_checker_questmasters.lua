-- Trigger: phase wand status checker questmasters
-- Zone: 2, ID: 114
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #314
--
-- The "[wand progress]" status handler shared by every wand questmaster mob from wandstep 3-10.
-- Reads the per-mob crafting parameters 002_111 exports through `globals` (type, weapon, wandstep,
-- wandattack, wandgem, wandtask3, wandtask4) and the player's <type>_wand quest variables, then
-- reports what is done and what is still needed. Globals hold legacy vnums; vkey() turns one into
-- the (zone, id) the catalog uses (zone 117 holds vnums 11700-11840).

local function vkey(vnum)
    if vnum >= 11700 and vnum <= 11840 then return 117, vnum - 11700 end
    return math.floor(vnum / 100), vnum % 100
end
local function oname(vnum)
    local z, i = vkey(vnum)
    return objects.template(z, i).name
end
local function mname(vnum)
    local z, i = vkey(vnum)
    return mobiles.template(z, i).name
end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local function set_(v) return v ~= nil and v ~= 0 and v ~= "" end

-- Who to see next, by quest type and the stage the player has already passed (DG #314 text).
local HINTS = {
    air = {
        [3] = "Speak with the old Abbot in the Abbey of St. George.",
        [4] = "The keeper of a southern coastal tower will have advice for you.",
        [5] = "A master of air near the megalith in South Caelia will be able to help next.",
        [6] = "Seek out the warrior-witch at the center of the southern megalith.",
        [7] = "She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you.",
        [8] = "In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work.",
        [9] = "The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips.",
        [10] = "Silania will help you craft the finest of air weapons.",
    },
    fire = {
        [3] = "A minion of the dark flame out east will know what to do.",
        [4] = "There's a fire master in the frozen north who likes to spend his time at the hot springs.",
        [5] = "A master of fire near the megalith in South Caelia will be able to help next.",
        [6] = "A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia.",
        [7] = "I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though...",
        [8] = "You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further.",
        [9] = "Seek out the one who speaks for the Sun near Anduin.  He can upgrade your staff.",
        [10] = "Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff.",
    },
    ice = {
        [3] = "The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.",
        [4] = "Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale.",
        [5] = "A master of spirits in the far north will be able to help next.",
        [6] = "Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets.",
        [7] = "You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite.",
        [8] = "There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting.",
        [9] = "The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him.",
        [10] = "You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff.",
    },
    acid = {
        [3] = "First, seek the one who guards the eastern gates of Ickle.",
        [4] = "The next two artisans dwell in the Rhell Forest south-east of Mielikki.",
        [5] = "Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance.",
        [6] = "The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay.",
        [7] = "Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert.",
        [8] = "Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you.",
        [9] = "The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her.",
        [10] = "Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff.",
    },
}

-- Where stage 8 sends the player to imbue the primed staff (DG `place`, set by 002_111).
local IMBUE_ROOM = { air = 49007, fire = 5272, ice = 55105, acid = 16355 }

-- Speech phrase: wand progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech or "") .. " "
if not string.find(speech_padded, "[%s%p]wand progress[%s%p]") then
    return true  -- Not the phrase
end
local wandstep = globals.wandstep
if not wandstep then return true end
wait(0.2)
if actor.class ~= "sorcerer" and actor.class ~= "cryomancer" and actor.class ~= "pyromancer"
        and actor.class ~= "illusionist" and actor.class ~= "necromancer" then
    self:say("This weapon is only for students of the arcane arts.")
    return true
end
local quest_type = globals.type
local weapon = globals.weapon
local wandgem = globals.wandgem
local wandtask3 = globals.wandtask3
local wandtask4 = globals.wandtask4
local quest = quest_type .. "_wand"
local stage = actor:get_quest_stage(quest)
local job1 = actor:get_quest_var(quest .. ":wandtask1")
local job2 = actor:get_quest_var(quest .. ":wandtask2")
local job3 = actor:get_quest_var(quest .. ":wandtask3")
local job4 = actor:get_quest_var(quest .. ":wandtask4")
local job5 = actor:get_quest_var(quest .. ":wandtask5")
local room = self.room

if actor:get_has_completed(quest) then
    self:say("It looks like you already have the most powerful staff of " .. quest_type .. " in existence!")
elseif stage == wandstep and actor.level >= (wandstep - 1) * 10 then
    if (actor:get_quest_var(quest .. ":greet") or 0) == 0 then
        self:say("Tell me why you're here first.")
    else
        self:say("I'm improving your " .. quest_type .. " weapon.")
        if set_(job1) or set_(job2) or set_(job3) or set_(job4) then
            room:send("")
            self:say("You've done the following:")
            if set_(job1) then
                room:send("- attacked " .. globals.wandattack .. " times")
            end
            if set_(job2) then
                room:send("- found " .. oname(wandgem))
            end
            if set_(job3) then
                if wandstep ~= 10 then
                    room:send("- found " .. oname(wandtask3))
                else
                    room:send("- slayed " .. mname(wandtask3))
                end
            end
            if set_(job4) then
                if wandstep ~= 5 and wandstep ~= 9 and wandstep ~= 10 then
                    room:send("- found " .. oname(wandtask4))
                elseif wandstep == 5 then
                    room:send("- communed in " .. tostring(wandtask4))
                elseif wandstep == 9 then
                    room:send("- slayed " .. mname(wandtask4))
                end
            end
        end
        room:send("")
        room:send("You need to:")
        if set_(job1) and set_(job2) and set_(job3) and set_(job4) then
            if wandstep ~= 6 and wandstep ~= 8 and wandstep ~= 10 then
                room:send("Just give me your " .. weapon .. ".")
            elseif wandstep == 6 then
                if not set_(job5) then
                    room:send("Just give me your " .. weapon .. ".")
                else
                    room:send("- <b:cyan>play</> " .. oname(wandtask4))
                end
            elseif wandstep == 8 then
                if not set_(job5) then
                    room:send("Just give me your " .. weapon .. ".")
                else
                    local imbue = get_room(vkey(IMBUE_ROOM[quest_type]))
                    room:send("- imbue your " .. weapon .. " at " .. tostring(imbue and imbue.name) .. ".")
                end
            elseif wandstep == 10 then
                local imbue = get_room(vkey(wandtask4))
                room:send("- imbue your " .. weapon .. " at " .. tostring(imbue and imbue.name) .. ".")
            end
        end
        if not set_(job1) then
            local counter = 50
            local remaining = ((stage - 1) * counter) - (actor:get_quest_var(quest .. ":attack_counter") or 0)
            room:send("- <b:yellow>attack " .. remaining .. " more times with your " .. weapon .. "</>")
        end
        if not set_(job2) then
            room:send("- <b:yellow>find " .. oname(wandgem) .. "</>")
        end
        if not set_(job3) then
            if wandstep ~= 10 then
                room:send("- <b:yellow>find " .. oname(wandtask3) .. "</>")
                if wandstep == 4 then
                    room:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                    if self.zone_id == 586 and self.id == 1 then
                        room:send("</>    Search the far eastern edge of the continent.")
                    elseif self.zone_id == 103 and self.id == 6 then
                        room:send("</>    Search the south point beyond Anlun Vale.")
                    elseif self.zone_id == 23 and self.id == 37 then
                        room:send("</>    Search the surrounding forest.")
                    elseif self.zone_id == 625 and self.id == 4 then
                        room:send("</>    Search in the heart of the heart of the thorns.")
                    end
                    room:send("</>    The phrase to call the blessing is:")
                    room:send("</>    <b:cyan>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                end
            else
                room:send("- <b:yellow>slay " .. mname(wandtask3) .. "</>")
            end
        end
        if not set_(job4) then
            if wandstep ~= 3 and wandstep ~= 5 and wandstep ~= 9 and wandstep ~= 10 then
                room:send("- <b:yellow>find " .. oname(wandtask4) .. "</>")
            elseif wandstep == 5 then
                if quest_type == "air" then
                    room:send("- <b:yellow>imbue your " .. weapon .. " on " .. tostring(wandtask4) .. "</>")
                else
                    room:send("- <b:yellow>imbue your " .. weapon .. " in " .. tostring(wandtask4) .. "</>")
                end
            elseif wandstep == 9 then
                room:send("- <b:yellow>slay " .. mname(wandtask4) .. "</>")
            elseif wandstep == 10 then
                if set_(job1) and set_(job2) and set_(job3) then
                    room:send("Just give me your " .. weapon .. ".")
                end
            end
        end
    end
elseif stage > wandstep then
    self:say("I can't help you anymore, but I know who can.")
    local hint = HINTS[quest_type] and HINTS[quest_type][stage]
    if hint then
        room:send("")
        self:say(hint)
    end
elseif stage < wandstep then
    self:say("You need to make more improvements to your " .. weapon .. " before I can work with it.")
elseif actor.level < (wandstep - 1) * 10 then
    self:say("Come back after you've gained some more experience.  I can help you then.")
end
return true
