-- Trigger: Honus cloak receive
-- Zone: 53, ID: 26
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
-- TODO(parity): branch-scoped `cloakstage`, `item`, `expmod`, `expcap`,
-- `accept` decls — used at outer scope. `%number%` is a literal DG
-- template inside set_quest_var (line 158) — should be `tostring(number)`
-- concat. Legacy 5-digit object ids; reward `(zone=123, id=117)` is a
-- legacy split. Full rewrite from DG #5326.
--
-- Original DG Script: #5326

-- Converted from DG Script #5326: Honus cloak receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
local cloakstage, item
do
    if (object.zone_id == 2 and object.id == 180) then
        cloakstage = 1
        item = "quest"
    elseif (object.zone_id == 588 and object.id == 1) then
        cloakstage = 1
        item = "cloak"
    elseif (object.zone_id == 555 and object.id == 85) then
        cloakstage = 1
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 181) then
        cloakstage = 2
        item = "quest"
    elseif (object.zone_id == 173 and object.id == 7) then
        cloakstage = 2
        item = "cloak"
    elseif (object.zone_id == 555 and object.id == 93) then
        cloakstage = 2
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 182) then
        cloakstage = 3
        item = "quest"
    elseif (object.zone_id == 103 and object.id == 8) then
        cloakstage = 3
        item = "cloak"
    elseif (object.zone_id == 556 and object.id == 19) then
        cloakstage = 3
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 183) then
        cloakstage = 4
        item = "quest"
    elseif (object.zone_id == 123 and object.id == 25) then
        cloakstage = 4
        item = "cloak"
    elseif (object.zone_id == 556 and object.id == 59) then
        cloakstage = 4
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 184) then
        cloakstage = 5
        item = "quest"
    elseif (object.zone_id == 430 and object.id == 22) then
        cloakstage = 5
        item = "cloak"
    elseif (object.zone_id == 556 and object.id == 63) then
        cloakstage = 5
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 185) then
        cloakstage = 6
        item = "quest"
    elseif (object.zone_id == 238 and object.id == 10) then
        cloakstage = 6
        item = "cloak"
    elseif (object.zone_id == 556 and object.id == 74) then
        cloakstage = 6
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 186) then
        cloakstage = 7
        item = "quest"
    elseif (object.zone_id == 510 and object.id == 13) then
        cloakstage = 7
        item = "cloak"
    elseif (object.zone_id == 557 and object.id == 14) then
        cloakstage = 7
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 187) then
        cloakstage = 8
        item = "quest"
    elseif (object.zone_id == 584 and object.id == 10) then
        cloakstage = 8
        item = "cloak"
    elseif (object.zone_id == 557 and object.id == 40) then
        cloakstage = 8
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 188) then
        cloakstage = 9
        item = "quest"
    elseif (object.zone_id == 520 and object.id == 9) then
        cloakstage = 9
        item = "cloak"
    elseif (object.zone_id == 557 and object.id == 41) then
        cloakstage = 9
        item = "gem"
    end
end
if actor:get_quest_stage("treasure_hunter") < actor:get_quest_stage("rogue_cloak") then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'Find some more treasure first.'")
    return false  -- legacy return 0: the giver keeps the item
elseif actor.level < (actor:get_quest_stage("rogue_cloak") * 10) then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    return false  -- legacy return 0: the giver keeps the item
elseif cloakstage > actor:get_quest_stage("rogue_cloak") then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'Your promotion doesn't involve that yet.  Be patient!'")
    return false  -- legacy return 0: the giver keeps the item
elseif cloakstage < actor:get_quest_stage("rogue_cloak") then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'You've already earned that promotion.'")
    return false  -- legacy return 0: the giver keeps the item
else
    local accept
    if item == "quest" then
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        if job1 and job2 and job3 and job4 then
            wait(0.2)
            local reward = object.id + 1
            world.destroy(object)
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Well done!  You've earned your promotion.'")
            self.room:spawn_object(math.floor(reward / 100), reward % 100)
            self:command("give cloak " .. tostring(actor))
            local expcap = cloakstage * 10
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
                actor:set_quest_var("rogue_cloak", "cloaktask%number%", 0)
                number = number + 1
            end
            if actor:get_quest_stage("rogue_cloak") < 9 then
                actor:advance_quest("rogue_cloak")
            else
                actor:complete_quest("rogue_cloak")
            end
        else
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'You need to do everything else before you trade in your cloak!'")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif item == "cloak" then
        if actor:get_quest_var("rogue_cloak:cloaktask2") == object.id then
            accept = "no"
        else
            accept = "yes"
            actor:set_quest_var("rogue_cloak", "cloaktask2", object.id)
        end
    elseif item == "gem" then
        if actor:get_quest_var("rogue_cloak:cloaktask3") == object.id then
            accept = "no"
        else
            accept = "yes"
            actor:set_quest_var("rogue_cloak", "cloaktask3", object.id)
        end
    end
    if accept == "no" then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif accept == "yes" then
        wait(0.2)
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