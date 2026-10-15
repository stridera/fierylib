-- Trigger: Berix bounty hunt receive
-- Zone: 60, ID: 53
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #6053

-- Converted from DG Script #6053: Berix bounty hunt receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Hoisted: branch-scoped `local` would not be visible to the rest of the script.
local stage, victim1, victim2, victim3, go, maskstage, item
-- switch on object.id
-- bounty contracts here
if (object.zone_id == 60 and object.id == 50) then
    stage = 1
    victim1 = "The King of the Meer Cats"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 51) then
    stage = 2
    victim1 = "the Noble"
    victim2 = "the Abbot"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 52) then
    stage = 3
    victim1 = "the O'Connor Chieftain"
    victim2 = "the McLeod Chieftain"
    victim3 = "the Cameron Chieftain"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 53) then
    stage = 4
    victim1 = "The Frakati Leader"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 54) then
    stage = 5
    victim1 = "Cyrus"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 55) then
    stage = 6
    victim1 = "Lord Venth"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 56) then
    stage = 7
    victim1 = "The high druid of Anlun Vale"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 57) then
    stage = 8
    victim1 = "The Lizard King"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 58) then
    stage = 9
    victim1 = "Sorcha"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 59) then
    stage = 10
    victim1 = "The Goblin King"
    go = "hunt"
    -- assassin mask items start here
elseif object.id == 350 then
    maskstage = 1
    item = "quest"
    go = "mask"
elseif (object.zone_id == 45 and object.id == 0) then
    maskstage = 1
    item = "mask"
    go = "mask"
elseif (object.zone_id == 555 and object.id == 92) then
    maskstage = 1
    item = "gem"
    go = "mask"
elseif object.id == 351 then
    maskstage = 2
    item = "quest"
    go = "mask"
elseif (object.zone_id == 178 and object.id == 9) then
    maskstage = 2
    item = "mask"
    go = "mask"
elseif (object.zone_id == 555 and object.id == 94) then
    maskstage = 2
    item = "gem"
    go = "mask"
elseif object.id == 352 then
    maskstage = 3
    item = "quest"
    go = "mask"
elseif (object.zone_id == 590 and object.id == 23) then
    maskstage = 3
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 20) then
    maskstage = 3
    item = "gem"
    go = "mask"
elseif object.id == 353 then
    maskstage = 4
    item = "quest"
    go = "mask"
elseif (object.zone_id == 103 and object.id == 4) then
    maskstage = 4
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 38) then
    maskstage = 4
    item = "gem"
    go = "mask"
elseif object.id == 354 then
    maskstage = 5
    item = "quest"
    go = "mask"
elseif (object.zone_id == 162 and object.id == 0) then
    maskstage = 5
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 66) then
    maskstage = 5
    item = "gem"
    go = "mask"
elseif object.id == 355 then
    maskstage = 6
    item = "quest"
    go = "mask"
elseif (object.zone_id == 430 and object.id == 17) then
    maskstage = 6
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 75) then
    maskstage = 6
    item = "gem"
    go = "mask"
elseif object.id == 356 then
    maskstage = 7
    item = "quest"
    go = "mask"
elseif (object.zone_id == 510 and object.id == 75) then
    maskstage = 7
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 93) then
    maskstage = 7
    item = "gem"
    go = "mask"
elseif object.id == 357 then
    maskstage = 8
    item = "quest"
    go = "mask"
elseif (object.zone_id == 490 and object.id == 62) then
    maskstage = 8
    item = "mask"
    go = "mask"
elseif (object.zone_id == 557 and object.id == 19) then
    maskstage = 8
    item = "gem"
    go = "mask"
elseif object.id == 358 then
    maskstage = 9
    item = "quest"
    go = "mask"
elseif (object.zone_id == 484 and object.id == 27) then
    maskstage = 9
    item = "mask"
    go = "mask"
elseif (object.zone_id == 557 and object.id == 43) then
    maskstage = 9
    item = "gem"
    go = "mask"
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    self:say("What is this for?")
    return _return_value
end
if go == "hunt" then
    -- Bug fix: the converter compared quest_stage to the string "stage" instead of
    -- the local variable `stage` set above; restore the variable comparison.
    if actor:get_quest_stage("bounty_hunt") == stage and actor:get_quest_var("bounty_hunt:bounty") == "dead" then
        wait(0.2)
        world.destroy(object)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'Well done.  Here's your payment.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        -- Hoisted: branch-scoped `local` would not be visible later.
        local expcap, expmod
        if stage == 1 then
            expcap = 5
        else
            expcap = (stage - 1) * 10
        end
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
        -- Bug fix: original referred to `person.class` but `person` is undefined
        -- here; use `actor.class`.
        if actor.class == "warrior" or actor.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "necromancer" or actor.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("bounty_hunt", "target1", 0)
        actor:set_quest_var("bounty_hunt", "target2", 0)
        actor:set_quest_var("bounty_hunt", "target3", 0)
        actor:set_quest_var("bounty_hunt", "bounty", 0)
        wait(0.2)
        if stage < 10 then
            actor:advance_quest("bounty_hunt")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
        else
            actor:complete_quest("bounty_hunt")
            actor:send(tostring(self.name) .. " says, 'Congratulations, you've really proven yourself out there!  'Fraid there ain't much more we can toss your way.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Take this to commemorate your hunt.'")
            self.room:spawn_object(4, 43)
            self:command("give shroud " .. tostring(actor))
        end
        if string.find(actor.class, "assassin") and actor:get_quest_stage("assassin_mask") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 150)
            self:command("give mask " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Masks like these show the rank of members of the Assassin Guild.'")
            actor:start_quest("assassin_mask")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This might be a good time to talk about a <b:cyan>[promotion]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that mask after you reach level 10 and let's talk about a promotion.'")
            end
        end
    elseif actor:get_quest_stage("bounty_hunt") > stage then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the contract.")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You already completed this contract!'")
    elseif actor:get_quest_stage("bounty_hunt") < stage then
        wait(0.2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the contract!")
        world.destroy(object)
    elseif actor:get_quest_var("bounty_hunt:bounty") ~= "dead" then
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses the contract.")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You have to finish the job first!'")
        if stage ~= 2 and stage ~= 3 then
            actor:send(tostring(victim1) .. " is still out there.")
        elseif stage == 2 or stage == 3 then
            if (actor:get_quest_var("bounty_hunt:target1") or 0) == 0 then
                actor:send(tostring(victim1) .. " is still out there.")
            end
            if (actor:get_quest_var("bounty_hunt:target2") or 0) == 0 then
                actor:send(tostring(victim2) .. " is still out there.")
            end
            if stage == 3 and (actor:get_quest_var("bounty_hunt:target3") or 0) == 0 then
                actor:send(tostring(victim3) .. " is still out there.")
            end
        end
    end
elseif go == "mask" then
    if actor:get_quest_stage("bounty_hunt") < actor:get_quest_stage("assassin_mask") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs first.'")
    elseif actor.level < (actor:get_quest_stage("assassin_mask") * 10) then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif maskstage > actor:get_quest_stage("assassin_mask") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Your mask doesn't involve that yet.  Be patient!'")
    elseif maskstage < actor:get_quest_stage("assassin_mask") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You've already gained that rank.'")
    else
        if item == "quest" then
            local job1 = actor:get_quest_var("assassin_mask:masktask1")
            local job2 = actor:get_quest_var("assassin_mask:masktask2")
            local job3 = actor:get_quest_var("assassin_mask:masktask3")
            local job4 = actor:get_quest_var("assassin_mask:masktask4")
            if job1 and job2 and job3 and job4 then
                wait(0.2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've proven your qualifications.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give mask " .. tostring(actor))
                local expcap = maskstage * 10
                -- Hoisted: branch-scoped `local expmod` would not be visible.
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
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    -- Bug fix: DG `%number%` interpolation; use Lua concat.
                    actor:set_quest_var("assassin_mask", "masktask" .. tostring(number), 0)
                    number = number + 1
                end
                if actor:get_quest_stage("assassin_mask") < 9 then
                    actor:advance_quest("assassin_mask")
                else
                    actor:complete_quest("assassin_mask")
                end
            else
                _return_value = true
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(0.2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you give me your guild mask!'")
            end
        end
        -- Hoisted: branch-scoped `local accept` would not be visible to the
        -- accept-check below. Default nil (skips the `accept` ladder when
        -- the item == "quest" branch above was taken).
        local accept
        if item == "mask" then
            if actor:get_quest_var("assassin_mask:masktask2") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("assassin_mask", "masktask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("assassin_mask:masktask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("assassin_mask", "masktask3", object.id)
            end
        end
        if accept == "no" then
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(0.2)
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        elseif accept == "yes" then
            wait(0.2)
            world.destroy(object)
            local job1 = actor:get_quest_var("assassin_mask:masktask1")
            local job2 = actor:get_quest_var("assassin_mask:masktask2")
            local job3 = actor:get_quest_var("assassin_mask:masktask3")
            local job4 = actor:get_quest_var("assassin_mask:masktask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now give me your guild mask for your promotion.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value