-- Trigger: Dragon Slayer Isilynor Receive
-- Zone: 30, ID: 83
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 19 if statements
--   Large script: 15100 chars
--
-- Original DG Script: #3083

-- Converted from DG Script #3083: Dragon Slayer Isilynor Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
if object.id == 3080 then
    local stage = 1
    local victim1 = "a dragon hedge"
    local go = "hunt"
elseif object.id == 3081 then
    local stage = 2
    local victim1 = "the green wyrmling"
    local go = "hunt"
elseif object.id == 3082 then
    local stage = 3
    local victim1 = "Wug the Fiery Drakling"
    local go = "hunt"
elseif object.id == 3083 then
    local stage = 4
    local victim1 = "the young blue dragon"
    local go = "hunt"
elseif object.id == 3084 then
    local stage = 5
    local victim1 = "a faerie dragon"
    local go = "hunt"
elseif object.id == 3085 then
    local stage = 6
    local victim1 = "the wyvern"
    local go = "hunt"
elseif object.id == 3086 then
    local stage = 7
    local victim1 = "an ice lizard"
    local go = "hunt"
elseif object.id == 3087 then
    local stage = 8
    local victim1 = "the Beast of Borgan"
    local go = "hunt"
elseif object.id == 3088 then
    local stage = 9
    local victim1 = "Tri-Aszp"
    local go = "hunt"
elseif object.id == 3089 then
    local stage = 10
    local victim1 = "the Hydra"
    local go = "hunt"
    -- paladin pendant items start here
elseif object.id == 360 then
    local pendantstage = 1
    local item = "quest"
    local go = "necklace"
elseif object.id == 12003 then
    local pendantstage = 1
    local item = "necklace"
    local go = "necklace"
elseif object.id == 55582 then
    local pendantstage = 1
    local item = "gem"
    local go = "necklace"
elseif object.id == 361 then
    local pendantstage = 2
    local item = "quest"
    local go = "necklace"
elseif object.id == 23708 then
    local pendantstage = 2
    local item = "necklace"
    local go = "necklace"
elseif object.id == 55590 then
    local pendantstage = 2
    local item = "gem"
    local go = "necklace"
elseif object.id == 362 then
    local pendantstage = 3
    local item = "quest"
    local go = "necklace"
elseif object.id == 58005 then
    local pendantstage = 3
    local item = "necklace"
    local go = "necklace"
elseif object.id == 55622 then
    local pendantstage = 3
    local item = "gem"
    local go = "necklace"
elseif object.id == 363 then
    local pendantstage = 4
    local item = "quest"
    local go = "necklace"
elseif object.id == 48123 then
    local pendantstage = 4
    local item = "necklace"
    local go = "necklace"
elseif object.id == 55654 then
    local pendantstage = 4
    local item = "gem"
    local go = "necklace"
elseif object.id == 364 then
    local pendantstage = 5
    local item = "quest"
    local go = "necklace"
elseif object.id == 12336 then
    local pendantstage = 5
    local item = "necklace"
    local go = "necklace"
elseif object.id == 55662 then
    local pendantstage = 5
    local item = "gem"
    local go = "necklace"
elseif object.id == 365 then
    local pendantstage = 6
    local item = "quest"
    local go = "necklace"
elseif object.id == 43019 then
    local pendantstage = 6
    local item = "necklace"
    local go = "necklace"
elseif object.id == 55677 then
    local pendantstage = 6
    local item = "gem"
    local go = "necklace"
elseif object.id == 366 then
    local pendantstage = 7
    local item = "quest"
    local go = "necklace"
elseif object.id == 37015 then
    local pendantstage = 7
    local item = "necklace"
    local go = "necklace"
elseif object.id == 55709 then
    local pendantstage = 7
    local item = "gem"
    local go = "necklace"
elseif object.id == 367 then
    local pendantstage = 8
    local item = "quest"
    local go = "necklace"
elseif object.id == 58429 then
    local pendantstage = 8
    local item = "necklace"
    local go = "necklace"
elseif object.id == 55738 then
    local pendantstage = 8
    local item = "gem"
    local go = "necklace"
elseif object.id == 368 then
    local pendantstage = 9
    local item = "quest"
    local go = "necklace"
elseif object.id == 52010 then
    local pendantstage = 9
    local item = "necklace"
    local go = "necklace"
elseif object.id == 55739 then
    local pendantstage = 9
    local item = "gem"
    local go = "necklace"
else
    _return_value = false
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
        if stage == 1 then
            local expcap = 5
        else
            local bonus = (stage - 1) * 10
            local expcap = bonus
        end
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
        -- switch on person.class
        if person.class == "Warrior" or person.class == "Berserker" then
            local expmod = (expmod + (expmod / 10))
        elseif person.class == "Paladin" or person.class == "%anti%" or person.class == "Ranger" then
            local expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "Sorcerer" or person.class == "Pyromancer" or person.class == "Cryomancer" or person.class == "Illusionist" or person.class == "Bard" then
            local expmod = (expmod + (expmod / 5))
        elseif person.class == "Necromancer" or person.class == "Monk" then
            local expmod = (expmod + (expmod * 2) / 5)
        else
            local expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            local loop = loop + 1
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
            self.room:spawn_object(5, 49)
            self:command("give crest " .. tostring(actor))
        end
        if (string.find(actor.class, "paladin") or string.find(actor.class, "anti")) and actor:get_quest_stage("paladin_pendant") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(3, 60)
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
        _return_value = false
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
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have to slay the dragon first!  " .. tostring(victim1) .. " is still out there.")
    end
elseif go == "necklace" then
    if actor:get_quest_stage("dragon_slayer") < actor:get_quest_stage("paladin_pendant") then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Slay some more dragons first.'")
    elseif actor.level < (actor:get_quest_stage("paladin_pendant") * 10) then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif pendantstage > actor:get_quest_stage("paladin_pendant") then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Your devotional act doesn't involve that yet.  Be patient!'")
    elseif pendantstage < actor:get_quest_stage("paladin_pendant") then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You've already performed that act of devotion.'")
    else
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
                self.room:spawn_object(vnum_to_zone(reward), vnum_to_local(reward))
                self:command("give necklace " .. tostring(actor))
                local expcap = pendantstage * 10
                if expcap < 17 then
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
                local expmod = expmod + ((expmod * 2) / 15)
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    local loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("paladin_pendant", "necklacetask%number%", 0)
                    local number = number + 1
                end
                if actor:get_quest_stage("paladin_pendant") < 9 then
                    actor:advance_quest("paladin_pendant")
                else
                    actor:complete_quest("paladin_pendant")
                end
            else
                _return_value = false
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you offer up your necklace!'")
            end
        elseif item == "necklace" then
            if actor:get_quest_var("paladin_pendant:necklacetask2") == object.id then
                local accept = "no"
            else
                local accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("paladin_pendant:necklacetask3") == object.id then
                local accept = "no"
            else
                local accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask3", object.id)
            end
        end
        if accept == "no" then
            _return_value = false
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