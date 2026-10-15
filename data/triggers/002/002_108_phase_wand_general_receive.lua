-- Trigger: phase wand general receive
-- Zone: 2, ID: 108
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #308
--
-- Generic receive handler for every wand questmaster from wandstep 3-10. Reads the per-mob crafting
-- parameters that 002_111 exports through `globals` (type, weapon, wandstep, wandgem, wandtask3,
-- wandtask4, wand_id = DG wandvnum) and the player's <type>_wand quest variables:
--   wandtask1 = used the weapon enough, wandtask2 = gave the gem, wandtask3 / wandtask4 = gave
--   (or achieved) the stage items, wandtask5 = weapon primed (stages 6 and 8).
-- A stage item is taken and ticked off; the weapon itself is only taken once everything else is
-- done, then it is upgraded (the next wand_id) and experience is awarded.
--
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands it
-- back with a give command (DG's `return 0`). Globals hold legacy vnums; vkey() turns one into the
-- (zone, id) the catalog uses (zone 2 holds vnums 200-399, zone 117 holds 11700-11840).

local function vkey(vnum)
    if vnum >= 200 and vnum <= 399 then return 2, vnum - 200 end
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
local function is_obj(vnum)
    if type(vnum) ~= "number" then return false end
    local z, i = vkey(vnum)
    return object.zone_id == z and object.id == i
end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local function set_(v) return v ~= nil and v ~= 0 and v ~= "" end

local function give_back()
    local bare = string.gsub(string.gsub(object.name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", "")
    self:command("give " .. bare .. " " .. actor.name)
end

local wandstep = globals.wandstep
if not wandstep then return true end
local quest_type = globals.type
local weapon = globals.weapon
local wandgem = globals.wandgem
local wandtask3 = globals.wandtask3
local wandtask4 = globals.wandtask4
local wandvnum = globals.wand_id
local quest = quest_type .. "_wand"
local reward = wandvnum + 1
local minlevel = (wandstep - 1) * 10
local vulcera = (self.zone_id == 481 and self.id == 5)

local job1 = actor:get_quest_var(quest .. ":wandtask1")
local job2 = actor:get_quest_var(quest .. ":wandtask2")
local job3 = actor:get_quest_var(quest .. ":wandtask3")
local job4 = actor:get_quest_var(quest .. ":wandtask4")
local job5 = actor:get_quest_var(quest .. ":wandtask5")
local stage = actor:get_quest_stage(quest)

if not (is_obj(wandgem) or is_obj(wandvnum) or is_obj(wandtask3) or is_obj(wandtask4)) then
    return true
end

-- Note: Vulcera (481/5) has slightly modified responses because she's a real asshole.
local response, check, continue
if stage == 0 then
    response = "You haven't even begun this process yet!"
elseif actor.level < minlevel then
    if vulcera then
        response = "You're far too pathetic to help yet."
    else
        response = "You'll need to be at least level " .. minlevel .. " before I can improve your bond with your weapon."
    end
elseif actor:get_has_completed(quest) then
    if vulcera then
        response = "Idiot.  You already have the most powerful " .. quest_type .. " staff a mere mortal can handle."
    else
        response = "You already have the most powerful " .. quest_type .. " staff in existence!"
    end
elseif stage < wandstep then
    if vulcera then
        response = "Your " .. weapon .. " is far too weak to craft."
    else
        response = "Your " .. weapon .. " isn't ready for improvement yet."
    end
elseif stage > wandstep then
    if vulcera then
        response = "You still expect more of me??  Bah!  Begone."
    else
        response = "I've done all I can already."
    end
elseif (actor:get_quest_var(quest .. ":greet") or 0) == 0 then
    response = "Tell me why you're here first."
elseif (is_obj(wandgem) and set_(job2)) or (is_obj(wandtask3) and set_(job3)) or (is_obj(wandtask4) and set_(job4))
        or ((stage == 6 or stage == 8) and is_obj(wandvnum) and set_(job5)) then
    response = "You already gave me this."
elseif is_obj(wandgem) then
    actor:set_quest_var(quest, "wandtask2", 1)
    check = "yes"
elseif is_obj(wandtask3) then
    actor:set_quest_var(quest, "wandtask3", 1)
    check = "yes"
elseif is_obj(wandtask4) then
    actor:set_quest_var(quest, "wandtask4", 1)
    check = "yes"
elseif is_obj(wandvnum) then
    job1 = actor:get_quest_var(quest .. ":wandtask1")
    job2 = actor:get_quest_var(quest .. ":wandtask2")
    job3 = actor:get_quest_var(quest .. ":wandtask3")
    job4 = actor:get_quest_var(quest .. ":wandtask4")
    if set_(job1) and set_(job2) and set_(job3) and set_(job4) then
        if stage ~= 3 and stage ~= 6 and stage ~= 8 and stage ~= 10 then
            continue = "yes"
        elseif stage == 6 or stage == 8 then
            actor:set_quest_var(quest, "wandtask5", 1)
            self:spawn_object(vkey(wandtask4))
            wait(0.2)
            if stage == 6 then
                wait(0.2)
                self.room:send(self.name .. " slides " .. oname(wandtask3) .. " around " .. oname(wandvnum) .. ".")
                wait(3)
                self.room:send(self.name .. " whispers some arcane syllables.")
                wait(3)
                self.room:send(oname(wandvnum) .. " begins to hum!")
                wait(2)
                self.room:send(self.name .. " says, 'Now, <b:cyan>play</> " .. oname(wandtask4) .. " to unlock your wand's full potential.'")
            elseif stage == 8 then
                local place
                if quest_type == "air" then
                    place = "the crystal megalith on Griffin Isle"
                elseif quest_type == "acid" then
                    place = "the sacred grove in the Highlands"
                elseif quest_type == "ice" then
                    place = "the Altar of the Snow Leopard"
                elseif quest_type == "fire" then
                    place = "the Fire Temple altar"
                end
                wait(0.2)
                self.room:send(self.name .. " utters a powerful enchantment over " .. object.shortdesc .. ".")
                wait(3)
                self.room:send(object.shortdesc .. " begins to glow!")
                wait(1)
                self.room:send(self.name .. " says, 'Now that your staff is primed, take both it and the ward to:")
                self.room:send("- <b:yellow>" .. tostring(place) .. "</>")
                self.room:send("</>and <b:cyan>imbue</> them both with the energies of that place to forge your new staff.'")
            end
            wait(0.2)
            self:command("give all " .. actor.name)
        end
    elseif set_(job1) and set_(job2) and set_(job3) then
        if stage == 10 then
            local room = get_room(vkey(wandtask4))
            actor:set_quest_var(quest, "wandtask4", 1)
            wait(0.2)
            self.room:send(self.name .. " utters eldritch incantations over " .. object.shortdesc .. ".")
            wait(2)
            self.room:send(object.shortdesc .. " begins to crackle with supreme elemental power!")
            wait(1)
            self.room:send(self.name .. " says, 'Now that you've captured the demon's energies, you must make your way deep into the elemental planes.  There, in the full glory of elemental " .. quest_type .. ", find <b:cyan>" .. tostring(room and room.name or "the plane's heart") .. "</> and <b:cyan>imbue</> it with the energy of the plane.'")
            wait(6)
            self:say("It will forge the most powerful staff of " .. quest_type .. " in all the realms!")
            self:command("give all " .. actor.name)
        elseif stage == 3 then
            continue = "yes"
        else
            continue = "no"
        end
    else
        continue = "no"
    end
else
    give_back()
    self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
    wait(0.2)
    self:say("What's that for?")
end

if continue == "yes" then
    wait(0.2)
    actor:advance_quest(quest)
    world.destroy(object)
    wait(1)
    self:say("Perfect, let me get to work.")
    wait(0.2)
    if stage ~= 7 then
        self.room:send(self.name .. " inlays " .. oname(wandgem) .. " in " .. oname(wandvnum) .. ".")
        wait(2)
    end
    if stage == 3 then
        self.room:send(self.name .. " burns " .. oname(wandtask3) .. " and passes " .. oname(wandvnum) .. " through the smoke.")
    elseif stage == 4 then
        self.room:send(self.name .. " melds " .. oname(wandtask3) .. " with " .. oname(wandvnum) .. ".")
        wait(2)
        self.room:send(self.name .. " binds " .. oname(wandtask4) .. " to the top of " .. oname(wandvnum) .. ".")
    elseif stage == 5 then
        self.room:send(self.name .. " discharges the potency of " .. oname(wandtask3) .. " into " .. oname(wandvnum) .. ".")
    elseif stage == 7 then
        if vulcera then
            self.room:send(self.name .. " lavishly discharges the power of " .. oname(wandvnum) .. " into " .. oname(wandtask3) .. ", transferring its power.")
        else
            self.room:send(self.name .. " discharges the power of " .. oname(wandvnum) .. " into " .. oname(wandtask3) .. ", transferring its power.")
        end
        wait(2)
        self.room:send(self.name .. " inlays " .. oname(wandgem) .. " in " .. oname(wandtask3) .. " and afixes " .. oname(wandtask4) .. " to the top.")
    elseif stage == 9 then
        self.room:send(self.name .. " carefully speaks an incantation to unravel the magic bindings of " .. oname(wandtask3) .. ".")
        wait(2)
        self.room:send(self.name .. " draws the power out of " .. oname(wandtask3) .. " and fuses it into " .. oname(wandvnum) .. ".")
    end
    wait(2)
    self.room:send(self.name .. " utters a few mystic words.")
    wait(1)
    if stage == 7 then
        self.room:send(oname(wandtask3) .. " is transformed into " .. oname(reward) .. "!")
    else
        self.room:send(oname(wandvnum) .. " is transformed into " .. oname(reward) .. "!")
    end
    wait(1)
    if stage == 7 then
        if vulcera then
            self:say("Here.  Be grateful.  Leave.")
        else
            self:say("Here you go, your new staff!")
        end
    else
        self:say("Here you go, your new " .. weapon .. "!")
    end
    self:spawn_object(vkey(reward))
    self:command("give all " .. actor.name)

    -- Experience: a level-band curve on the step's level cap, scaled by class so every class
    -- receives the same proportion of a level.
    local expcap = (wandstep - 1) * 10
    local expmod = 0
    if expcap < 9 then
        expmod = math.floor(((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    local class = actor.class
    if class == "warrior" or class == "berserker" then
        expmod = expmod + math.floor(expmod / 10)
    elseif class == "paladin" or class == "anti-paladin" or class == "ranger" then
        expmod = expmod + math.floor((expmod * 2) / 15)
    elseif class == "sorcerer" or class == "pyromancer" or class == "cryomancer" or class == "illusionist" or class == "bard" then
        expmod = expmod + math.floor(expmod / 5)
    elseif class == "necromancer" or class == "monk" then
        expmod = expmod + math.floor((expmod * 2) / 5)
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 5 do
        actor:award_exp(setexp)
    end
    actor:set_quest_var(quest, "greet", 0)
    actor:set_quest_var(quest, "attack_counter", 0)
    for number = 1, 5 do
        actor:set_quest_var(quest, "wandtask" .. number, 0)
    end
elseif continue == "no" then
    give_back()
    self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
    wait(0.2)
    if not set_(job1) and (not set_(job2) or not set_(job3) or not set_(job4)) then
        local counter = 50
        local remaining = ((actor:get_quest_stage(quest) - 1) * counter) - (actor:get_quest_var(quest .. ":attack_counter") or 0)
        self.room:send(self.name .. " says, 'You still need to attack <b:yellow>" .. remaining .. "</> more times to fully bond with your " .. weapon .. "!'")
        wait(1)
        self:say("I need the other items as well.")
    elseif set_(job1) and (not set_(job2) or not set_(job3) or not set_(job4)) then
        self:say("You have to give me everything else first.")
    end
elseif check == "yes" then
    wait(0.2)
    world.destroy(object)
    self:say("This is just what I need.")
    wait(0.2)
    job1 = actor:get_quest_var(quest .. ":wandtask1")
    job2 = actor:get_quest_var(quest .. ":wandtask2")
    job3 = actor:get_quest_var(quest .. ":wandtask3")
    job4 = actor:get_quest_var(quest .. ":wandtask4")
    if set_(job1) and set_(job2) and set_(job3) and set_(job4) then
        if stage ~= 3 and stage ~= 6 and stage ~= 8 and stage ~= 10 then
            self:say("That's everything!  Now just give me your " .. weapon .. ".")
        elseif stage == 6 or stage == 8 then
            self:say("Let me prime your " .. weapon .. ".")
        end
    elseif (set_(job1) and set_(job2) and set_(job3)) and (stage == 10 or stage == 5 or stage == 3 or stage == 9) then
        if stage == 10 then
            self:say("Let me prime your " .. weapon .. ".")
        elseif stage == 3 then
            self:say("That's everything!  Now just give me your " .. weapon .. ".")
        elseif stage == 5 then
            self.room:send(self.name .. " says, 'Now go <b:cyan>imbue</> your " .. weapon .. " at " .. tostring(wandtask4) .. " and bring it back to me.'")
        elseif stage == 9 then
            self:say("Now go defeat " .. mname(wandtask4) .. ".")
        end
    elseif set_(job1) and set_(job2) and stage == 10 then
        self:say("Now go defeat " .. mname(wandtask3) .. ".")
    elseif (stage == 3 or stage == 10) and (not set_(job1) and set_(job2) and set_(job3)) then
        self:say("Finish bonding with your " .. weapon .. " and bring it to me.")
    elseif not set_(job1) and set_(job2) and set_(job3) and set_(job4) then
        self:say("Finish bonding with your " .. weapon .. " and bring it to me.")
    else
        self:say("Do you have the rest?")
    end
elseif response then
    give_back()
    self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
    wait(0.2)
    self:say(response)
end
return true
