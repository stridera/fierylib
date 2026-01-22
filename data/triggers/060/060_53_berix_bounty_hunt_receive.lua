-- Trigger: Berix bounty hunt receive
-- Zone: 60, ID: 53
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 23 if statements
--   Large script: 15393 chars
--
-- Original DG Script: #6053

-- Converted from DG Script #6053: Berix bounty hunt receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- bounty contracts here
if object.id == 6050 then
    local stage = 1
    local victim1 = "The King of the Meer Cats"
    local go = "hunt"
elseif object.id == 6051 then
    local stage = 2
    local victim1 = "the Noble"
    local victim2 = "the Abbot"
    local go = "hunt"
elseif object.id == 6052 then
    local stage = 3
    local victim1 = "the O'Connor Chieftain"
    local victim2 = "the McLeod Chieftain"
    local victim3 = "the Cameron Chieftain"
    local go = "hunt"
elseif object.id == 6053 then
    local stage = 4
    local victim1 = "The Frakati Leader"
    local go = "hunt"
elseif object.id == 6054 then
    local stage = 5
    local victim1 = "Cyrus"
    local go = "hunt"
elseif object.id == 6055 then
    local stage = 6
    local victim1 = "Lord Venth"
    local go = "hunt"
elseif object.id == 6056 then
    local stage = 7
    local victim1 = "The high druid of Anlun Vale"
    local go = "hunt"
elseif object.id == 6057 then
    local stage = 8
    local victim1 = "The Lizard King"
    local go = "hunt"
elseif object.id == 6058 then
    local stage = 9
    local victim1 = "Sorcha"
    local go = "hunt"
elseif object.id == 6059 then
    local stage = 10
    local victim1 = "The Goblin King"
    local go = "hunt"
    -- assassin mask items start here
elseif object.id == 350 then
    local maskstage = 1
    local item = "quest"
    local go = "mask"
elseif object.id == 4500 then
    local maskstage = 1
    local item = "mask"
    local go = "mask"
elseif object.id == 55592 then
    local maskstage = 1
    local item = "gem"
    local go = "mask"
elseif object.id == 351 then
    local maskstage = 2
    local item = "quest"
    local go = "mask"
elseif object.id == 17809 then
    local maskstage = 2
    local item = "mask"
    local go = "mask"
elseif object.id == 55594 then
    local maskstage = 2
    local item = "gem"
    local go = "mask"
elseif object.id == 352 then
    local maskstage = 3
    local item = "quest"
    local go = "mask"
elseif object.id == 59023 then
    local maskstage = 3
    local item = "mask"
    local go = "mask"
elseif object.id == 55620 then
    local maskstage = 3
    local item = "gem"
    local go = "mask"
elseif object.id == 353 then
    local maskstage = 4
    local item = "quest"
    local go = "mask"
elseif object.id == 10304 then
    local maskstage = 4
    local item = "mask"
    local go = "mask"
elseif object.id == 55638 then
    local maskstage = 4
    local item = "gem"
    local go = "mask"
elseif object.id == 354 then
    local maskstage = 5
    local item = "quest"
    local go = "mask"
elseif object.id == 16200 then
    local maskstage = 5
    local item = "mask"
    local go = "mask"
elseif object.id == 55666 then
    local maskstage = 5
    local item = "gem"
    local go = "mask"
elseif object.id == 355 then
    local maskstage = 6
    local item = "quest"
    local go = "mask"
elseif object.id == 43017 then
    local maskstage = 6
    local item = "mask"
    local go = "mask"
elseif object.id == 55675 then
    local maskstage = 6
    local item = "gem"
    local go = "mask"
elseif object.id == 356 then
    local maskstage = 7
    local item = "quest"
    local go = "mask"
elseif object.id == 51075 then
    local maskstage = 7
    local item = "mask"
    local go = "mask"
elseif object.id == 55693 then
    local maskstage = 7
    local item = "gem"
    local go = "mask"
elseif object.id == 357 then
    local maskstage = 8
    local item = "quest"
    local go = "mask"
elseif object.id == 49062 then
    local maskstage = 8
    local item = "mask"
    local go = "mask"
elseif object.id == 55719 then
    local maskstage = 8
    local item = "gem"
    local go = "mask"
elseif object.id == 358 then
    local maskstage = 9
    local item = "quest"
    local go = "mask"
elseif object.id == 48427 then
    local maskstage = 9
    local item = "mask"
    local go = "mask"
elseif object.id == 55743 then
    local maskstage = 9
    local item = "gem"
    local go = "mask"
else
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("What is this for?")
    return _return_value
end
if go == "hunt" then
    if actor:get_quest_stage("bounty_hunt") == "stage" and actor:get_quest_var("bounty_hunt:bounty") == "dead" then
        wait(2)
        world.destroy(object)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'Well done.  Here's your payment.'")
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
        elseif person.class == "Paladin" or person.class == "Anti-Paladin" or person.class == "Ranger" then
            local expmod = (expmod + ((expmod * 2) / 15)
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
        actor:set_quest_var("bounty_hunt", "target1", 0)
        actor:set_quest_var("bounty_hunt", "target2", 0)
        actor:set_quest_var("bounty_hunt", "target3", 0)
        actor:set_quest_var("bounty_hunt", "bounty", 0)
        wait(2)
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
        if string.find(actor.class, "Assassin") and actor:get_quest_stage("assassin_mask") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(3, 50)
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
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the contract.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You already completed this contract!'")
    elseif actor:get_quest_stage("bounty_hunt") < stage then
        wait(2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the contract!")
        world.destroy(object)
    elseif actor:get_quest_var("bounty_hunt:bounty") ~= "dead" then
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses the contract.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have to finish the job first!'")
        if stage ~= 2 and stage ~= 3 then
            actor:send(tostring(victim1) .. " is still out there.")
        elseif stage == 2 or stage == 3 then
            if not actor:get_quest_var("bounty_hunt:target1") then
                actor:send(tostring(victim1) .. " is still out there.")
            end
            if not actor:get_quest_var("bount_hunt:target2") then
                actor:send(tostring(victim2) .. " is still out there.")
            end
            if stage == 3 and not actor:get_quest_var("bounty_hunt:target3") then
                actor:send(tostring(victim3) .. " is still out there.")
            end
        end
    end
elseif go == "mask" then
    if actor:get_quest_stage("bounty_hunt") < actor:get_quest_stage("assassin_mask") then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs first.'")
    elseif actor.level < (actor:get_quest_stage("assassin_mask") * 10) then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif maskstage > actor:get_quest_stage("assassin_mask") then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Your mask doesn't involve that yet.  Be patient!'")
    elseif maskstage < actor:get_quest_stage("assassin_mask") then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You've already gained that rank.'")
    else
        if item == "quest" then
            local job1 = actor:get_quest_var("assassin_mask:masktask1")
            local job2 = actor:get_quest_var("assassin_mask:masktask2")
            local job3 = actor:get_quest_var("assassin_mask:masktask3")
            local job4 = actor:get_quest_var("assassin_mask:masktask4")
            if job1 and job2 and job3 and job4 then
                wait(2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've proven your qualifications.'")
                self.room:spawn_object(vnum_to_zone(reward), vnum_to_local(reward))
                self:command("give mask " .. tostring(actor))
                local expcap = maskstage * 10
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
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    local loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("assassin_mask", "masktask%number%", 0)
                    local number = number + 1
                end
                if actor:get_quest_stage("assassin_mask") < 9 then
                    actor:advance_quest("assassin_mask")
                else
                    actor:complete_quest("assassin_mask")
                end
            else
                _return_value = false
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you give me your guild mask!'")
            end
        elseif item == "mask" then
            if actor:get_quest_var("assassin_mask:masktask2") == object.id then
                local accept = "no"
            else
                local accept = "yes"
                actor:set_quest_var("assassin_mask", "masktask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("assassin_mask:masktask3") == object.id then
                local accept = "no"
            else
                local accept = "yes"
                actor:set_quest_var("assassin_mask", "masktask3", object.id)
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