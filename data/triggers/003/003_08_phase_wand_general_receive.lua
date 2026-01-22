-- Trigger: phase wand general receive
-- Zone: 3, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 24 if statements
--   Large script: 15235 chars
--
-- Original DG Script: #308

-- Converted from DG Script #308: phase wand general receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local job1 = actor.quest_variable[type_wand:wandtask1]
local job2 = actor.quest_variable[type_wand:wandtask2]
local job3 = actor.quest_variable[type_wand:wandtask3]
local job4 = actor.quest_variable[type_wand:wandtask4]
local job5 = actor.quest_variable[type_wand:wandtask5]
local reward = wandvnum + 1
local stage = actor.quest_stage[type_wand]
if object.id == "wandgem" or object.id == "wandvnum" or object.id == "wandtask2" or object.id == "wandtask3" or object.id == "wandtask4" then
    -- Note: Mob 48105 is Vulcera.  She has slightly modified responses because she's a real asshole.
    if not stage then
        -- Are they on the quest?
        local response = "You haven't even begun this process yet!"
    elseif actor.level < ((wandstep - 1) * 10) then
        -- Are they the right level?
        if self.id == 48105 then
            local response = "You're far too pathetic to help yet."
        else
            local response = You'll need to be at least level minlevel before I can improve your bond with your weapon.
        end
    elseif actor.has_completed[type_wand] then
        -- Have they already completed the quest?
        if self.id == 48105 then
            local response = Idiot.  You already have the most powerful type staff a mere mortal can handle.
        else
            local response = You already have the most powerful type staff in existence!
        end
    elseif stage < wandstep then
        -- Are they below this step still?
        if self.id == 48105 then
            local response = Your weapon is far too weak to craft.
        else
            local response = Your weapon isn't ready for improvement yet.
        end
    elseif stage > wandstep then
        -- Are they past this step but not yet completed?
        if self.id == 48105 then
            local response = "You still expect more of me??  Bah!  Begone."
        else
            local response = "I've done all I can already."
        end
    elseif actor.quest_variable[type_wand:greet] == 0 then
        -- Have they greeted the quest master properly?
        local response = "Tell me why you're here first."
    elseif (object.id == "wandgem" and job2) or (object.id == "wandtask3" and job3) or (object.id == "wandtask4" and job4) or ((stage == 6 or stage == 8) and object.id == "wandvnum" and job5) then
        -- Have they already given the crafter this item?
        local response = "You already gave me this."
    elseif object.id == "wandgem" then
        actor:set_quest_var("%type%_wand", "wandtask2", 1)
        local check = "yes"
    elseif object.id == "wandtask3" then
        actor:set_quest_var("%type%_wand", "wandtask3", 1)
        local check = "yes"
    elseif object.id == "wandtask4" then
        actor:set_quest_var("%type%_wand", "wandtask4", 1)
        local check = "yes"
    elseif object.id == "wandvnum" then
        local job1 = actor.quest_variable[type_wand:wandtask1]
        local job2 = actor.quest_variable[type_wand:wandtask2]
        local job3 = actor.quest_variable[type_wand:wandtask3]
        local job4 = actor.quest_variable[type_wand:wandtask4]
        if job1 and job2 and job3 and job4 then
            if stage ~= 3 and stage ~= 6 and stage ~= 8 and stage ~= 10 then
                local continue = "yes"
            elseif stage == 6 or stage == 8 then
                actor:set_quest_var("%type%_wand", "wandtask5", 1)
                self.room:spawn_object(vnum_to_zone(wandtask4), vnum_to_local(wandtask4))
                wait(2)
                if stage == 6 then
                    wait(2)
                    self.room:send(tostring(self.name) .. " slides " .. "%get.obj_shortdesc[%wandtask3%]% around %get.obj_shortdesc[%wandvnum%]%.")
                    wait(3)
                    self.room:send(tostring(self.name) .. " whispers some arcane syllables.")
                    wait(3)
                    self.room:send("%get.obj_shortdesc[%wandvnum%]% begins to hum!")
                    wait(2)
                    self.room:send(tostring(self.name) .. " says, 'Now, <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]% to unlock your wand's full potential.'")
                elseif stage == 8 then
                    if type == "air" then
                        local place = "the crystal megalith on Griffin Isle"
                    elseif type == "acid" then
                        local place = "the sacred grove in the Highlands"
                    elseif type == "ice" then
                        local place = "the Altar of the Snow Leopard"
                    elseif type == "fire" then
                        local place = "the Fire Temple altar"
                    end
                    wait(2)
                    self.room:send(tostring(self.name) .. " utters a powerful enchantment over " .. tostring(object.shortdesc) .. ".")
                    wait(3)
                    self.room:send(tostring(object.shortdesc) .. " begins to glow!")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, 'Now that your staff is primed, take both it and the ward to:")
                    self.room:send("- <b:yellow>" .. tostring(place) .. "</>")
                    self.room:send("</>and <b:cyan>imbue</> them both with the energies of that place to forge your new staff.'")
                end
                wait(2)
                self:command("give all " .. tostring(actor))
            end
        elseif job1 and job2 and job3 then
            if stage == 10 then
                local room = get.room[wandtask4]
                actor:set_quest_var("%type%_wand", "wandtask4", 1)
                wait(2)
                self.room:send(tostring(self.name) .. " utters eldritch incantations over " .. tostring(object.shortdesc) .. ".")
                wait(2)
                self.room:send(tostring(object.shortdesc) .. " begins to crackle with supreme elemental power!")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'Now that you've captured the demon's energies, you must make your way deep into the elemental planes.  There, in the full glory of elemental " .. tostring(type) .. ", find <b:cyan>" .. tostring(room.name) .. "</> and <b:cyan>imbue</> it with the energy of the plane.'")
                wait(6)
                self:say("It will forge the most powerful staff of " .. tostring(type) .. " in all the realms!")
                self:command("give all " .. tostring(actor))
            elseif stage == 3 then
                local continue = "yes"
            else
                local continue = "no"
            end
        else
            local continue = "no"
        end
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("What's that for?")
    end
    if continue == "yes" then
        wait(2)
        actor:advance_quest("%type%_wand")
        world.destroy(object)
        wait(1)
        self:say("Perfect, let me get to work.")
        wait(2)
        if stage ~= 7 then
            self.room:send(tostring(self.name) .. " inlays " .. "%get.obj_shortdesc[%wandgem%]% in %get.obj_shortdesc[%wandvnum%]%.")
            wait(2)
        end
        if stage == 3 then
            self.room:send(tostring(self.name) .. " burns " .. "%get.obj_shortdesc[%wandtask3%]% and passes %get.obj_shortdesc[%wandvnum%]% through the smoke.")
        elseif stage == 4 then
            self.room:send(tostring(self.name) .. " melds " .. "%get.obj_shortdesc[%wandtask3%]% with %get.obj_shortdesc[%wandvnum%]%.")
            wait(2)
            self.room:send(tostring(self.name) .. " binds " .. "%get.obj_shortdesc[%wandtask4%]% to the top of %get.obj_shortdesc[%wandvnum%]%.")
        elseif stage == 5 then
            self.room:send(tostring(self.name) .. " discharges the potency of " .. "%get.obj_shortdesc[%wandtask3%]% into %get.obj_shortdesc[%wandvnum%]%.")
        elseif stage == 7 then
            if self.id == 48105 then
                self.room:send(tostring(self.name) .. " lavishly discharges the power of " .. "%get.obj_shortdesc[%wandvnum%]% into %get.obj_shortdesc[%wandtask3%]%, transferring its power.")
            else
                self.room:send(tostring(self.name) .. " discharges the power of " .. "%get.obj_shortdesc[%wandvnum%]% into %get.obj_shortdesc[%wandtask3%]%, transferring its power.")
            end
            wait(2)
            self.room:send(tostring(self.name) .. " inlays " .. "%get.obj_shortdesc[%wandgem%]% in %get.obj_shortdesc[%wandtask3%]% and afixes %get.obj_shortdesc[%wandtask4%]% to the top.")
        elseif stage == 9 then
            self.room:send(tostring(self.name) .. " carefully speaks an incantation to unravel the magic bindings of " .. "%get.obj_shortdesc[%wandtask3%]%.")
            wait(2)
            self.room:send(tostring(self.name) .. " draws the power out of " .. "%get.obj_shortdesc[%wandtask3%]% and fuses it into %get.obj_shortdesc[%wandvnum%]%.")
        end
        wait(2)
        self.room:send(tostring(self.name) .. " utters a few mystic words.")
        wait(1)
        if stage == 7 then
            self.room:send("%get.obj_shortdesc[%wandtask3%]% is transformed into %get.obj_shortdesc[%reward%]%!")
        else
            self.room:send("%get.obj_shortdesc[%wandvnum%]% is transformed into %get.obj_shortdesc[%reward%]%!")
        end
        wait(1)
        if stage == 7 then
            if self.id == 48105 then
                self:say("Here.  Be grateful.  Leave.")
            else
                self:say("Here you go, your new staff!")
            end
        else
            self:say("Here you go, your new " .. tostring(weapon) .. "!")
        end
        self.room:spawn_object(vnum_to_zone(reward), vnum_to_local(reward))
        self:command("give all " .. tostring(actor))
        local expcap = ((wandstep - 1) * 10)
        local expmod = 0
        if expcap < 9 then
            local expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            local expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            local expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            local expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            local expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            local expmod = 8640 + ((expcap - 48) * 300)
        else
            local expmod = 20940 + ((expcap - 89) * 600)
        end
        -- Adjust exp award by class so all classes receive the same proportionate amount
        -- switch on actor.class
        if actor.class == "Warrior" or actor.class == "Berserker" then
            -- 110% of standard
            local expmod = (expmod + (expmod / 10))
        elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
            -- 115% of standard
            local expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
            -- 120% of standard
            local expmod = (expmod + (expmod / 5))
        elseif actor.class == "Necromancer" or actor.class == "Monk" then
            -- 130% of standard
            local expmod = (expmod + (expmod * 2) / 5)
        else
            local expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 5 do
            actor:award_exp(setexp)
            local loop = loop + 1
        end
        actor:set_quest_var("%type%_wand", "greet", 0)
        actor:set_quest_var("%type%_wand", "attack_counter", 0)
        local number = 1
        while number <= 5 do
            actor:set_quest_var("%type%_wand", "wandtask%number%", 0)
            local number = number + 1
        end
    elseif continue == "no" then
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        if not job1 and (not job2 or not job3 or not job4) then
            local counter = 50
            local remaining = ((actor.quest_stage[type_wand] - 1) * counter) - actor.quest_variable[type_wand:attack_counter]
            self.room:send(tostring(self.name) .. " says, 'You still need to attack <b:yellow>" .. tostring(remaining) .. "</> more times to fully bond with your " .. tostring(weapon) .. "!'")
            wait(1)
            self:say("I need the other items as well.")
        elseif job1 and (not job2 or not job3 or not job4) then
            self:say("You have to give me everything else first.")
        end
    elseif check == "yes" then
        wait(2)
        world.destroy(object)
        self:say("This is just what I need.")
        wait(2)
        local job1 = actor.quest_variable[type_wand:wandtask1]
        local job2 = actor.quest_variable[type_wand:wandtask2]
        local job3 = actor.quest_variable[type_wand:wandtask3]
        local job4 = actor.quest_variable[type_wand:wandtask4]
        if job1 and job2 and job3 and job4 then
            if stage ~= 3 and stage ~= 6 and stage ~= 8 and stage ~= 10 then
                self:say("That's everything!  Now just give me your " .. tostring(weapon) .. ".")
            elseif stage == 6 or stage == 8 then
                self:say("Let me prime your " .. tostring(weapon) .. ".")
            end
        elseif (job1 and job2 and job3) and (stage == 10 or stage == 5 or stage == 3 or stage == 9) then
            if stage == 10 then
                self:say("Let me prime your " .. tostring(weapon) .. ".")
            elseif stage == 3 then
                self:say("That's everything!  Now just give me your " .. tostring(weapon) .. ".")
            elseif stage == 5 then
                self.room:send(tostring(self.name) .. " says, 'Now go <b:cyan>imbue</> your " .. tostring(weapon) .. " at " .. tostring(wandtask4) .. " and bring it back to me.'")
            elseif stage == 9 then
                self:say("Now go defeat " .. "%get.mob_shortdesc[%wandtask4%]%.")
            end
        elseif job1 and job2 and stage == 10 then
            self:say("Now go defeat " .. "%get.mob_shortdesc[%wandtask3%]%.")
        elseif (stage == 3 or stage == 10) and (not job1 and job2 and job3) then
            self:say("Finish bonding with your " .. tostring(weapon) .. " and bring it to me.")
        elseif not job1 and job2 and job3 and job4 then
            self:say("Finish bonding with your " .. tostring(weapon) .. " and bring it to me.")
        else
            self:say("Do you have the rest?")
        end
    elseif response then
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say(tostring(response))
    end
end
return _return_value