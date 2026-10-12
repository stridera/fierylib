-- Trigger: Dragon Slayer Isilynor Receive
-- Zone: 30, ID: 83
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REWRITE
--
-- TODO(parity): converter declared `local stage`, `local victim1`, `local go`,
-- `local pendantstage`, `local item`, `local accept`, `local expmod`,
-- `local expcap`, etc. inside every if/elseif branch. They are nil at the
-- outer-scope checks (`if go == "hunt"`, `if accept == "no"`, etc.). Hoist
-- those declarations to the top of the trigger and drop the `local` keyword
-- in branches.
--
-- Also: line 205 references `person.class == "anti-paladin"` which is a stray DG-
-- Script interpolation; should be `actor.class == anti` (with `anti` declared
-- as `"Anti-Paladin"` in line 174). And `person` itself is never assigned in
-- this trigger — should iterate `actor.group_member` or just use `actor`.
--
-- Also: `actor:set_quest_var("paladin_pendant", "necklacetask%number%", 0)`
-- on line 331 should be `"necklacetask" .. tostring(number)`.
--
-- Original DG Script: #3083

-- Converted from DG Script #3083: Dragon Slayer Isilynor Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
local stage, victim1, go, pendantstage, item
if (object.zone_id == 30 and object.id == 80) then
    stage = 1
    victim1 = "a dragon hedge"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 81) then
    stage = 2
    victim1 = "the green wyrmling"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 82) then
    stage = 3
    victim1 = "Wug the Fiery Drakling"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 83) then
    stage = 4
    victim1 = "the young blue dragon"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 84) then
    stage = 5
    victim1 = "a faerie dragon"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 85) then
    stage = 6
    victim1 = "the wyvern"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 86) then
    stage = 7
    victim1 = "an ice lizard"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 87) then
    stage = 8
    victim1 = "the Beast of Borgan"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 88) then
    stage = 9
    victim1 = "Tri-Aszp"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 89) then
    stage = 10
    victim1 = "the Hydra"
    go = "hunt"
    -- paladin pendant items start here
elseif object.id == 360 then
    pendantstage = 1
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 120 and object.id == 3) then
    pendantstage = 1
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 555 and object.id == 82) then
    pendantstage = 1
    item = "gem"
    go = "necklace"
elseif object.id == 361 then
    pendantstage = 2
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 237 and object.id == 8) then
    pendantstage = 2
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 555 and object.id == 90) then
    pendantstage = 2
    item = "gem"
    go = "necklace"
elseif object.id == 362 then
    pendantstage = 3
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 580 and object.id == 5) then
    pendantstage = 3
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 22) then
    pendantstage = 3
    item = "gem"
    go = "necklace"
elseif object.id == 363 then
    pendantstage = 4
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 481 and object.id == 23) then
    pendantstage = 4
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 54) then
    pendantstage = 4
    item = "gem"
    go = "necklace"
elseif object.id == 364 then
    pendantstage = 5
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 123 and object.id == 36) then
    pendantstage = 5
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 62) then
    pendantstage = 5
    item = "gem"
    go = "necklace"
elseif object.id == 365 then
    pendantstage = 6
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 430 and object.id == 19) then
    pendantstage = 6
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 77) then
    pendantstage = 6
    item = "gem"
    go = "necklace"
elseif object.id == 366 then
    pendantstage = 7
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 370 and object.id == 15) then
    pendantstage = 7
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 9) then
    pendantstage = 7
    item = "gem"
    go = "necklace"
elseif object.id == 367 then
    pendantstage = 8
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 584 and object.id == 29) then
    pendantstage = 8
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 38) then
    pendantstage = 8
    item = "gem"
    go = "necklace"
elseif object.id == 368 then
    pendantstage = 9
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 520 and object.id == 10) then
    pendantstage = 9
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 39) then
    pendantstage = 9
    item = "gem"
    go = "necklace"
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("What is this for?")
    return _return_value
end
if go == "hunt" then
    if actor:get_quest_stage("dragon_slayer") == "stage" and actor:get_quest_var("dragon_slayer:hunt") == "dead" then
        local anti = "Anti-Paladin"
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
        actor:set_quest_var("dragon_slayer", "target1", 0)
        actor:set_quest_var("dragon_slayer", "hunt", 0)
        wait(2)
        if stage < 10 then
            actor:advance_quest("dragon_slayer")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
        else
            actor:complete_quest("dragon_slayer")
            actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest dragon slayers in the realm!'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'I bestow upon you this crest in recognition of your might.  Wear this proudly.'")
            self.room:spawn_object(4, 149)
            self:command("give crest " .. tostring(actor))
        end
        if (string.find(actor.class, "paladin") or string.find(actor.class, "anti")) and actor:get_quest_stage("paladin_pendant") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 160)
            self:command("give necklace " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Necklaces like these are proof of your devotion to your causes.'")
            actor:start_quest("paladin_pendant")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This is an opportune time to further prove your <b:cyan>[devotion]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that necklace after you reach level 10.  We can discuss acts of devotion then.'")
            end
        end
    elseif actor:get_quest_stage("dragon_slayer") > stage then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You already killed this dragon!'")
    elseif actor:get_quest_stage("dragon_slayer") < stage then
        wait(2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the notice!")
        world.destroy(object)
    elseif actor:get_quest_var("dragon_slayer:hunt") ~= "dead" then
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have to slay the dragon first!  " .. tostring(victim1) .. " is still out there.")
    end
elseif go == "necklace" then
    if actor:get_quest_stage("dragon_slayer") < actor:get_quest_stage("paladin_pendant") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Slay some more dragons first.'")
    elseif actor.level < (actor:get_quest_stage("paladin_pendant") * 10) then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif pendantstage > actor:get_quest_stage("paladin_pendant") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Your devotional act doesn't involve that yet.  Be patient!'")
    elseif pendantstage < actor:get_quest_stage("paladin_pendant") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You've already performed that act of devotion.'")
    else
        local accept
        if item == "quest" then
            local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
            local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
            local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
            local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
            if job1 and job2 and job3 and job4 then
                wait(2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've proven your devotion.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give necklace " .. tostring(actor))
                local expcap = pendantstage * 10
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
                expmod = expmod + ((expmod * 2) / 15)
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("paladin_pendant", "necklacetask%number%", 0)
                    number = number + 1
                end
                if actor:get_quest_stage("paladin_pendant") < 9 then
                    actor:advance_quest("paladin_pendant")
                else
                    actor:complete_quest("paladin_pendant")
                end
            else
                _return_value = true
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you offer up your necklace!'")
            end
        elseif item == "necklace" then
            if actor:get_quest_var("paladin_pendant:necklacetask2") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("paladin_pendant:necklacetask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask3", object.id)
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
            local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
            local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
            local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
            local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now turn over your current necklace as the final proof of your devotion.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value