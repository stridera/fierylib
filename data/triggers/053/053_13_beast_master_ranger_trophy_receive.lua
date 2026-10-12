-- Trigger: Beast Master Ranger Trophy receive
-- Zone: 53, ID: 13
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
-- TODO(parity): `local stage`, `local victim1`, `local trophystage`,
-- `local item`, `local go`, `local accept`, `local expmod`, `local expcap`
-- are all branch-scoped via `local` inside elseif arms — referenced later
-- in the function so they read nil. Also: `actor:get_quest_stage("...") ==
-- "stage"` compares stage int to literal string "stage". Legacy 5-digit
-- vnums for object.id (5300, 1607, 55579, etc.) need split to (zone, id).
-- `person.class` referenced where actor is meant. `%anti%` should be
-- `anti` variable. Full rewrite needed from DG #5313.
--
-- Original DG Script: #5313

-- Converted from DG Script #5313: Beast Master Ranger Trophy receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
local stage, victim1, go, trophystage, item
if (object.zone_id == 53 and object.id == 0) then
    stage = 1
    victim1 = "an abominable slime creature"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 1) then
    stage = 2
    victim1 = "a large buck"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 2) then
    stage = 3
    victim1 = "the giant scorpion"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 3) then
    stage = 4
    victim1 = "a monstrous canopy spider"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 4) then
    stage = 5
    victim1 = "the chimera"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 5) then
    stage = 6
    victim1 = "the drider king"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 6) then
    stage = 7
    victim1 = "a beholder"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 7) then
    stage = 8
    victim1 = "the Banshee"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 8) then
    stage = 9
    victim1 = "Baba Yaga"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 9) then
    stage = 10
    victim1 = "the medusa"
    go = "hunt"
    -- ranger trophy items start here
elseif object.id == 370 then
    trophystage = 1
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 16 and object.id == 7) then
    trophystage = 1
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 555 and object.id == 79) then
    trophystage = 1
    item = "gem"
    go = "trophy"
elseif object.id == 371 then
    trophystage = 2
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 178 and object.id == 6) then
    trophystage = 2
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 555 and object.id == 91) then
    trophystage = 2
    item = "gem"
    go = "trophy"
elseif object.id == 372 then
    trophystage = 3
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 18 and object.id == 5) then
    trophystage = 3
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 28) then
    trophystage = 3
    item = "gem"
    go = "trophy"
elseif object.id == 373 then
    trophystage = 4
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 625 and object.id == 13) then
    trophystage = 4
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 52) then
    trophystage = 4
    item = "gem"
    go = "trophy"
elseif object.id == 374 then
    trophystage = 5
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 238 and object.id == 3) then
    trophystage = 5
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 64) then
    trophystage = 5
    item = "gem"
    go = "trophy"
elseif object.id == 375 then
    trophystage = 6
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 430 and object.id == 9) then
    trophystage = 6
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 85) then
    trophystage = 6
    item = "gem"
    go = "trophy"
elseif object.id == 376 then
    trophystage = 7
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 470 and object.id == 8) then
    trophystage = 7
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 5) then
    trophystage = 7
    item = "gem"
    go = "trophy"
elseif object.id == 377 then
    trophystage = 8
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 533 and object.id == 23) or (object.zone_id == 533 and object.id == 11) then
    trophystage = 8
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 29) then
    trophystage = 8
    item = "gem"
    go = "trophy"
elseif object.id == 378 then
    trophystage = 9
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 520 and object.id == 14) then
    trophystage = 9
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 41) then
    trophystage = 9
    item = "gem"
    go = "trophy"
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("What is this for?")
    return _return_value
end
if go == "hunt" then
    if actor:get_quest_stage("beast_master") == "stage" and actor:get_quest_var("beast_master:hunt") == "dead" then
        wait(2)
        world.destroy(object)
        self:command("cheer")
        actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        local expcap
        if stage == 1 then
            expcap = 5
        else
            local bonus = (stage - 1) * 10
            expcap = bonus
        end
        local expmod
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
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
        local anti = "Anti-Paladin"
        -- switch on person.class
        local expmod
        if person.class == "warrior" or person.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif person.class == "paladin" or person.class == "anti-paladin" or person.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "sorcerer" or person.class == "pyromancer" or person.class == "cryomancer" or person.class == "illusionist" or person.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif person.class == "necromancer" or person.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        else
            expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("beast_master", "target1", 0)
        actor:set_quest_var("beast_master", "hunt", 0)
        wait(2)
        if stage < 10 then
            actor:advance_quest("beast_master")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more hunts.'")
        else
            actor:complete_quest("beast_master")
            actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest Beast Masters in the realm!'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Take these gloves.  Wear them to show everyone your unstoppable prowess.'")
            self.room:spawn_object(4, 13)
            self:command("give gloves " .. tostring(actor))
        end
        if (string.find(actor.class, "ranger") or string.find(actor.class, "warrior") or string.find(actor.class, "berserker") or string.find(actor.class, "Mercenary")) and actor:get_quest_stage("ranger_trophy") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 170)
            self:command("give trophy " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Trophies like these are proof of your skill as a hunter.'")
            actor:start_quest("ranger_trophy")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This is an opportune time to further demonstrate your <b:cyan>[skill]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that trophy after you reach level 10.  We can discuss your skills then.'")
            end
        end
    elseif actor:get_quest_stage("beast_master") > stage then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You already killed this creature!'")
    elseif actor:get_quest_stage("beast_master") < stage then
        wait(2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the notice!")
        world.destroy(object)
    elseif actor:get_quest_var("beast_master:hunt") ~= "dead" then
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have to slay kill the beast first!  " .. tostring(victim1) .. " is still out there.")
    end
elseif go == "trophy" then
    if actor.class ~= "warrior" and actor.class ~= "ranger" and actor.class ~= "mercenary" and actor.class ~= "berserker" then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, '" .. tostring(actor.class) .. "s aren't fit for these kinds of tests.'")
    elseif actor:get_quest_stage("beast_master") < actor:get_quest_stage("ranger_trophy") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Defeat some more monsters first.'")
    elseif actor.level < (actor:get_quest_stage("ranger_trophy") * 10) then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif trophystage > actor:get_quest_stage("ranger_trophy") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You don't need that to demonstrate your skills yet.  Be patient!'")
    elseif trophystage < actor:get_quest_stage("ranger_trophy") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You've already used that as proof.'")
    else
        local accept
        if item == "quest" then
            local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
            local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
            local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
            local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
            if job1 and job2 and job3 and job4 then
                wait(2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've demonstrated your skills well.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give trophy " .. tostring(actor))
                local expcap = trophystage * 10
                local expmod
                if expcap < 17 then
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
                -- switch on person.class
                local expmod
                if person.class == "warrior" or person.class == "berserker" then
                    expmod = (expmod + (expmod / 10))
                elseif person.class == "ranger" then
                    expmod = (expmod + ((expmod * 2) / 15))
                else
                    expmod = expmod
                end
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("ranger_trophy", "trophytask%number%", 0)
                    number = number + 1
                end
                if actor:get_quest_stage("ranger_trophy") < 9 then
                    actor:advance_quest("ranger_trophy")
                else
                    actor:complete_quest("ranger_trophy")
                end
            else
                _return_value = true
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you exchange your trophy!'")
            end
        elseif item == "trophy" then
            local task2 = actor:get_quest_var("ranger_trophy:trophytask2")
            if task2 == object.id or ((object.zone_id == 533 and object.id == 11) and task2 == 53323) or ((object.zone_id == 533 and object.id == 23) and task2 == 53311) then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("ranger_trophy:trophytask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask3", object.id)
            end
        end
        if accept == "no" then
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        elseif accept == "yes" then
            wait(2)
            world.destroy(object)
            local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
            local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
            local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
            local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now give me your current trophy.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value