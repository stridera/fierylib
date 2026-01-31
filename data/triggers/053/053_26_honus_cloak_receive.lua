-- Trigger: Honus cloak receive
-- Zone: 53, ID: 26
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 7418 chars
--
-- Original DG Script: #5326

-- Converted from DG Script #5326: Honus cloak receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == 380 then
    local cloakstage = 1
    local item = "quest"
elseif object.id == 58801 then
    local cloakstage = 1
    local item = "cloak"
elseif object.id == 55585 then
    local cloakstage = 1
    local item = "gem"
elseif object.id == 381 then
    local cloakstage = 2
    local item = "quest"
elseif object.id == 17307 then
    local cloakstage = 2
    local item = "cloak"
elseif object.id == 55593 then
    local cloakstage = 2
    local item = "gem"
elseif object.id == 382 then
    local cloakstage = 3
    local item = "quest"
elseif object.id == 10308 then
    local cloakstage = 3
    local item = "cloak"
elseif object.id == 55619 then
    local cloakstage = 3
    local item = "gem"
elseif object.id == 383 then
    local cloakstage = 4
    local item = "quest"
elseif object.id == 12325 then
    local cloakstage = 4
    local item = "cloak"
elseif object.id == 55659 then
    local cloakstage = 4
    local item = "gem"
elseif object.id == 384 then
    local cloakstage = 5
    local item = "quest"
elseif object.id == 43022 then
    local cloakstage = 5
    local item = "cloak"
elseif object.id == 55663 then
    local cloakstage = 5
    local item = "gem"
elseif object.id == 385 then
    local cloakstage = 6
    local item = "quest"
elseif object.id == 23810 then
    local cloakstage = 6
    local item = "cloak"
elseif object.id == 55674 then
    local cloakstage = 6
    local item = "gem"
elseif object.id == 386 then
    local cloakstage = 7
    local item = "quest"
elseif object.id == 51013 then
    local cloakstage = 7
    local item = "cloak"
elseif object.id == 55714 then
    local cloakstage = 7
    local item = "gem"
elseif object.id == 387 then
    local cloakstage = 8
    local item = "quest"
elseif object.id == 58410 then
    local cloakstage = 8
    local item = "cloak"
elseif object.id == 55740 then
    local cloakstage = 8
    local item = "gem"
elseif object.id == 388 then
    local cloakstage = 9
    local item = "quest"
elseif object.id == 52009 then
    local cloakstage = 9
    local item = "cloak"
elseif object.id == 55741 then
    local cloakstage = 9
    local item = "gem"
end
if actor:get_quest_stage("treasure_hunter") < actor:get_quest_stage("rogue_cloak") then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Find some more treasure first.'")
elseif actor.level < (actor:get_quest_stage("rogue_cloak") * 10) then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
elseif cloakstage > actor:get_quest_stage("rogue_cloak") then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Your promotion doesn't involve that yet.  Be patient!'")
elseif cloakstage < actor:get_quest_stage("rogue_cloak") then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You've already earned that promotion.'")
else
    if item == "quest" then
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        if job1 and job2 and job3 and job4 then
            wait(2)
            local reward = object.id + 1
            local reward_zone, reward_local = reward // 100, reward % 100
            if reward_zone == 0 then reward_zone = 1000 end
            world.destroy(object)
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Well done!  You've earned your promotion.'")
            self.room:spawn_object(reward_zone, reward_local)
            self:command("give cloak " .. tostring(actor))
            local expcap = cloakstage * 10
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
                actor:set_quest_var("rogue_cloak", "cloaktask" .. number, 0)
                local number = number + 1
            end
            if actor:get_quest_stage("rogue_cloak") < 9 then
                actor:advance_quest("rogue_cloak")
            else
                actor:complete_quest("rogue_cloak")
            end
        else
            _return_value = false
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You need to do everything else before you trade in your cloak!'")
        end
    elseif item == "cloak" then
        if actor:get_quest_var("rogue_cloak:cloaktask2") == object.id then
            local accept = "no"
        else
            local accept = "yes"
            actor:set_quest_var("rogue_cloak", "cloaktask2", object.id)
        end
    elseif item == "gem" then
        if actor:get_quest_var("rogue_cloak:cloaktask3") == object.id then
            local accept = "no"
        else
            local accept = "yes"
            actor:set_quest_var("rogue_cloak", "cloaktask3", object.id)
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
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        if job1 and job2 and job3 and job4 then
            actor:send(tostring(self.name) .. " says, 'Excellent.  Now trade in your cloak for your promotion.'")
        else
            actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
        end
    end
end
return _return_value