-- Trigger: Beast Master Ranger Trophy receive
-- Zone: 53, ID: 13
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 20 if statements
--   Large script: 15840 chars
--
-- Original DG Script: #5313

-- Converted from DG Script #5313: Beast Master Ranger Trophy receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
if object.id == 5300 then
    local stage = 1
    local victim1 = "an abominable slime creature"
    local go = "hunt"
elseif object.id == 5301 then
    local stage = 2
    local victim1 = "a large buck"
    local go = "hunt"
elseif object.id == 5302 then
    local stage = 3
    local victim1 = "the giant scorpion"
    local go = "hunt"
elseif object.id == 5303 then
    local stage = 4
    local victim1 = "a monstrous canopy spider"
    local go = "hunt"
elseif object.id == 5304 then
    local stage = 5
    local victim1 = "the chimera"
    local go = "hunt"
elseif object.id == 5305 then
    local stage = 6
    local victim1 = "the drider king"
    local go = "hunt"
elseif object.id == 5306 then
    local stage = 7
    local victim1 = "a beholder"
    local go = "hunt"
elseif object.id == 5307 then
    local stage = 8
    local victim1 = "the Banshee"
    local go = "hunt"
elseif object.id == 5308 then
    local stage = 9
    local victim1 = "Baba Yaga"
    local go = "hunt"
elseif object.id == 5309 then
    local stage = 10
    local victim1 = "the medusa"
    local go = "hunt"
    -- ranger trophy items start here
elseif object.id == 370 then
    local trophystage = 1
    local item = "quest"
    local go = "trophy"
elseif object.id == 1607 then
    local trophystage = 1
    local item = "trophy"
    local go = "trophy"
elseif object.id == 55579 then
    local trophystage = 1
    local item = "gem"
    local go = "trophy"
elseif object.id == 371 then
    local trophystage = 2
    local item = "quest"
    local go = "trophy"
elseif object.id == 17806 then
    local trophystage = 2
    local item = "trophy"
    local go = "trophy"
elseif object.id == 55591 then
    local trophystage = 2
    local item = "gem"
    local go = "trophy"
elseif object.id == 372 then
    local trophystage = 3
    local item = "quest"
    local go = "trophy"
elseif object.id == 1805 then
    local trophystage = 3
    local item = "trophy"
    local go = "trophy"
elseif object.id == 55628 then
    local trophystage = 3
    local item = "gem"
    local go = "trophy"
elseif object.id == 373 then
    local trophystage = 4
    local item = "quest"
    local go = "trophy"
elseif object.id == 62513 then
    local trophystage = 4
    local item = "trophy"
    local go = "trophy"
elseif object.id == 55652 then
    local trophystage = 4
    local item = "gem"
    local go = "trophy"
elseif object.id == 374 then
    local trophystage = 5
    local item = "quest"
    local go = "trophy"
elseif object.id == 23803 then
    local trophystage = 5
    local item = "trophy"
    local go = "trophy"
elseif object.id == 55664 then
    local trophystage = 5
    local item = "gem"
    local go = "trophy"
elseif object.id == 375 then
    local trophystage = 6
    local item = "quest"
    local go = "trophy"
elseif object.id == 43009 then
    local trophystage = 6
    local item = "trophy"
    local go = "trophy"
elseif object.id == 55685 then
    local trophystage = 6
    local item = "gem"
    local go = "trophy"
elseif object.id == 376 then
    local trophystage = 7
    local item = "quest"
    local go = "trophy"
elseif object.id == 47008 then
    local trophystage = 7
    local item = "trophy"
    local go = "trophy"
elseif object.id == 55705 then
    local trophystage = 7
    local item = "gem"
    local go = "trophy"
elseif object.id == 377 then
    local trophystage = 8
    local item = "quest"
    local go = "trophy"
elseif object.id == 53323 or object.id == 53311 then
    local trophystage = 8
    local item = "trophy"
    local go = "trophy"
elseif object.id == 55729 then
    local trophystage = 8
    local item = "gem"
    local go = "trophy"
elseif object.id == 378 then
    local trophystage = 9
    local item = "quest"
    local go = "trophy"
elseif object.id == 52014 then
    local trophystage = 9
    local item = "trophy"
    local go = "trophy"
elseif object.id == 55741 then
    local trophystage = 9
    local item = "gem"
    local go = "trophy"
else
    _return_value = false
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
        local anti = "Anti-Paladin"
        -- switch on person.class
        if person.class == "Warrior" or person.class == "Berserker" then
            local expmod = (expmod + (expmod / 10))
        elseif person.class == "Paladin" or person.class == anti or person.class == "Ranger" then
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
            self.room:spawn_object(3, 70)
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
        _return_value = false
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
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have to slay kill the beast first!  " .. tostring(victim1) .. " is still out there.")
    end
elseif go == "trophy" then
    if actor.class ~= "warrior" and actor.class ~= "ranger" and actor.class ~= "mercenary" and actor.class ~= "berserker" then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, '" .. tostring(actor.class) .. "s aren't fit for these kinds of tests.'")
    elseif actor:get_quest_stage("beast_master") < actor:get_quest_stage("ranger_trophy") then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Defeat some more monsters first.'")
    elseif actor.level < (actor:get_quest_stage("ranger_trophy") * 10) then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif trophystage > actor:get_quest_stage("ranger_trophy") then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You don't need that to demonstrate your skills yet.  Be patient!'")
    elseif trophystage < actor:get_quest_stage("ranger_trophy") then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You've already used that as proof.'")
    else
        if item == "quest" then
            local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
            local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
            local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
            local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
            if job1 and job2 and job3 and job4 then
                wait(2)
                local reward = object.id + 1
                local reward_zone, reward_local = reward // 100, reward % 100
                if reward_zone == 0 then reward_zone = 1000 end
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've demonstrated your skills well.'")
                self.room:spawn_object(reward_zone, reward_local)
                self:command("give trophy " .. tostring(actor))
                local expcap = trophystage * 10
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
                -- switch on person.class
                if person.class == "Warrior" or person.class == "Berserker" then
                    local expmod = (expmod + (expmod / 10))
                elseif person.class == "Ranger" then
                    local expmod = (expmod + ((expmod * 2) / 15))
                else
                    local expmod = expmod
                end
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    local loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("ranger_trophy", "trophytask" .. number, 0)
                    number = number + 1
                end
                if actor:get_quest_stage("ranger_trophy") < 9 then
                    actor:advance_quest("ranger_trophy")
                else
                    actor:complete_quest("ranger_trophy")
                end
            else
                _return_value = false
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you exchange your trophy!'")
            end
        elseif item == "trophy" then
            local task2 = actor:get_quest_var("ranger_trophy:trophytask2")
            if task2 == object.id or (object.id == 53311 and task2 == 53323) or (object.id == 53323 and task2 == 53311) then
                local accept = "no"
            else
                local accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("ranger_trophy:trophytask3") == object.id then
                local accept = "no"
            else
                local accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask3", object.id)
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