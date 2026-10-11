-- Trigger: Monk Vision Hakujo receive
-- Zone: 53, ID: 40
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
-- TODO(parity): branch-scoped `visionstage`, `item`, `expmod`, `expcap`,
-- `accept`. `%number%` literal in set_quest_var (line 158). Legacy
-- 5-digit object ids. Full rewrite from DG #5340.
--
-- Original DG Script: #5340

-- Converted from DG Script #5340: Monk Vision Hakujo receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
local visionstage, item
if object.id == 390 then
    visionstage = 1
    item = "quest"
elseif (object.zone_id == 590 and object.id == 6) then
    visionstage = 1
    item = "book"
elseif (object.zone_id == 555 and object.id == 82) then
    visionstage = 1
    item = "gem"
elseif object.id == 391 then
    visionstage = 2
    item = "quest"
elseif (object.zone_id == 185 and object.id == 5) then
    visionstage = 2
    item = "book"
elseif (object.zone_id == 555 and object.id == 91) then
    visionstage = 2
    item = "gem"
elseif object.id == 392 then
    visionstage = 3
    item = "quest"
elseif (object.zone_id == 85 and object.id == 1) then
    visionstage = 3
    item = "book"
elseif (object.zone_id == 556 and object.id == 23) then
    visionstage = 3
    item = "gem"
elseif object.id == 393 then
    visionstage = 4
    item = "quest"
elseif (object.zone_id == 125 and object.id == 32) then
    visionstage = 4
    item = "book"
elseif (object.zone_id == 556 and object.id == 55) then
    visionstage = 4
    item = "gem"
elseif object.id == 394 then
    visionstage = 5
    item = "quest"
elseif (object.zone_id == 162 and object.id == 9) then
    visionstage = 5
    item = "book"
elseif (object.zone_id == 556 and object.id == 65) then
    visionstage = 5
    item = "gem"
elseif object.id == 395 then
    visionstage = 6
    item = "quest"
elseif (object.zone_id == 430 and object.id == 13) then
    visionstage = 6
    item = "book"
elseif (object.zone_id == 556 and object.id == 78) then
    visionstage = 6
    item = "gem"
elseif object.id == 396 then
    visionstage = 7
    item = "quest"
elseif (object.zone_id == 530 and object.id == 9) then
    visionstage = 7
    item = "book"
elseif (object.zone_id == 557 and object.id == 10) then
    visionstage = 7
    item = "gem"
elseif object.id == 397 then
    visionstage = 8
    item = "quest"
elseif (object.zone_id == 584 and object.id == 15) then
    visionstage = 8
    item = "book"
elseif (object.zone_id == 557 and object.id == 22) then
    visionstage = 8
    item = "gem"
elseif object.id == 398 then
    visionstage = 9
    item = "quest"
elseif (object.zone_id == 584 and object.id == 12) then
    visionstage = 9
    item = "book"
elseif (object.zone_id == 557 and object.id == 41) then
    visionstage = 9
    item = "gem"
end
if actor:get_quest_stage("elemental_chaos") < actor:get_quest_stage("monk_vision") then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Undertake more missions in service of Balance first.'")
elseif actor.level < (actor:get_quest_stage("monk_vision") * 10) then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
elseif visionstage > actor:get_quest_stage("monk_vision") then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Your vision doesn't involve that yet.  Be patient!'")
elseif visionstage < actor:get_quest_stage("monk_vision") then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You've already seen that vision.'")
else
    local accept
    if item == "quest" then
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        if job1 and job2 and job3 and job4 then
            wait(2)
            local reward = object.id + 1
            world.destroy(object)
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Well done!  You've earned your next vision mark.'")
            self.room:spawn_object(math.floor(reward / 100), reward % 100)
            self:command("give vision " .. tostring(actor))
            local expcap = visionstage * 10
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
                actor:set_quest_var("monk_vision", "visiontask%number%", 0)
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
            _return_value = true
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You need to do everything else before you trade in your vision mark!'")
        end
    elseif item == "book" or item == "gem" then
        if not actor:get_quest_var("monk_vision:visiontask4") then
            _return_value = true
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(actor) .. " " .. tostring(self.name) .. " says, 'You need to bring the gem and the text to the prescribed place and read first.'")
            return _return_value
        else
            if item == "book" then
                if actor:get_quest_var("monk_vision:visiontask3") == object.id then
                    accept = "no"
                else
                    accept = "yes"
                    actor:set_quest_var("monk_vision", "visiontask3", object.id)
                end
            elseif item == "gem" then
                if actor:get_quest_var("monk_vision:visiontask2") == object.id then
                    accept = "no"
                else
                    accept = "yes"
                    actor:set_quest_var("monk_vision", "visiontask2", object.id)
                end
            end
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