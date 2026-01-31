-- Trigger: Monk Vision Hakujo receive
-- Zone: 53, ID: 40
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--   Large script: 8964 chars
--
-- Original DG Script: #5340

-- Converted from DG Script #5340: Monk Vision Hakujo receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == 390 then
    local visionstage = 1
    local item = "quest"
elseif object.id == 59006 then
    local visionstage = 1
    local item = "book"
elseif object.id == 55582 then
    local visionstage = 1
    local item = "gem"
elseif object.id == 391 then
    local visionstage = 2
    local item = "quest"
elseif object.id == 18505 then
    local visionstage = 2
    local item = "book"
elseif object.id == 55591 then
    local visionstage = 2
    local item = "gem"
elseif object.id == 392 then
    local visionstage = 3
    local item = "quest"
elseif object.id == 8501 then
    local visionstage = 3
    local item = "book"
elseif object.id == 55623 then
    local visionstage = 3
    local item = "gem"
elseif object.id == 393 then
    local visionstage = 4
    local item = "quest"
elseif object.id == 12532 then
    local visionstage = 4
    local item = "book"
elseif object.id == 55655 then
    local visionstage = 4
    local item = "gem"
elseif object.id == 394 then
    local visionstage = 5
    local item = "quest"
elseif object.id == 16209 then
    local visionstage = 5
    local item = "book"
elseif object.id == 55665 then
    local visionstage = 5
    local item = "gem"
elseif object.id == 395 then
    local visionstage = 6
    local item = "quest"
elseif object.id == 43013 then
    local visionstage = 6
    local item = "book"
elseif object.id == 55678 then
    local visionstage = 6
    local item = "gem"
elseif object.id == 396 then
    local visionstage = 7
    local item = "quest"
elseif object.id == 53009 then
    local visionstage = 7
    local item = "book"
elseif object.id == 55710 then
    local visionstage = 7
    local item = "gem"
elseif object.id == 397 then
    local visionstage = 8
    local item = "quest"
elseif object.id == 58415 then
    local visionstage = 8
    local item = "book"
elseif object.id == 55722 then
    local visionstage = 8
    local item = "gem"
elseif object.id == 398 then
    local visionstage = 9
    local item = "quest"
elseif object.id == 58412 then
    local visionstage = 9
    local item = "book"
elseif object.id == 55741 then
    local visionstage = 9
    local item = "gem"
end
if actor:get_quest_stage("elemental_chaos") < actor:get_quest_stage("monk_vision") then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Undertake more missions in service of Balance first.'")
elseif actor.level < (actor:get_quest_stage("monk_vision") * 10) then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
elseif visionstage > actor:get_quest_stage("monk_vision") then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Your vision doesn't involve that yet.  Be patient!'")
elseif visionstage < actor:get_quest_stage("monk_vision") then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You've already seen that vision.'")
else
    if item == "quest" then
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        if job1 and job2 and job3 and job4 then
            wait(2)
            local reward = object.id + 1
            local reward_zone, reward_local = reward // 100, reward % 100
            if reward_zone == 0 then reward_zone = 1000 end
            world.destroy(object)
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Well done!  You've earned your next vision mark.'")
            self.room:spawn_object(reward_zone, reward_local)
            self:command("give vision " .. tostring(actor))
            local expcap = visionstage * 10
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
                actor:set_quest_var("monk_vision", "visiontask" .. number, 0)
                number = number + 1
            end
            if actor:get_quest_stage("monk_vision") < 9 then
                actor:advance_quest("monk_vision")
            else
                actor:complete_quest("monk_vision")
            end
            if actor:get_quest_stage("monk_vision") >= 4 then
                wait(2)
                if not actor:get_quest_stage("monk_chants") then
                    actor:send(tostring(self.name) .. " says, 'Your awareness has grown enough to handle the esoteric <b:cyan>[chants]</>.  I can give you instruction if you wish.'")
                elseif (actor:get_quest_stage("monk_chants") == 7 and actor.level < 75) or (actor:get_quest_stage("monk_chants") > 9 and actor.level < 99) then
                    actor:send(tostring(self.name) .. " says, 'You will be ready for a new chant once you have gained more experience.'")
                else
                    actor:send(tostring(self.name) .. " says, 'Your awareness has grown enough to comprehend a new esoteric <b:cyan>[chant]</>.'")
                end
            end
        else
            _return_value = false
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You need to do everything else before you trade in your vision mark!'")
        end
    elseif item == "book" or item == "gem" then
        if not actor:get_quest_var("monk_vision:visiontask4") then
            _return_value = false
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(actor) .. " " .. tostring(self.name) .. " says, 'You need to bring the gem and the text to the prescribed place and read first.'")
            return _return_value
        else
            if item == "book" then
                if actor:get_quest_var("monk_vision:visiontask3") == object.id then
                    local accept = "no"
                else
                    local accept = "yes"
                    actor:set_quest_var("monk_vision", "visiontask3", object.id)
                end
            elseif item == "gem" then
                if actor:get_quest_var("monk_vision:visiontask2") == object.id then
                    local accept = "no"
                else
                    local accept = "yes"
                    actor:set_quest_var("monk_vision", "visiontask2", object.id)
                end
            end
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
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        if job1 and job2 and job3 and job4 then
            actor:send(tostring(self.name) .. " says, 'Excellent.  Now trade in your current vision mark.'")
        else
            actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
        end
    end
end
return _return_value