-- Trigger: Elemental Chaos Hakujo mission receive
-- Zone: 53, ID: 38
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--   Large script: 5588 chars
--
-- Original DG Script: #5338

-- Converted from DG Script #5338: Elemental Chaos Hakujo mission receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- mission targets here
if object.id == 5320 then
    local stage = 1
    local target1 = "an imp"
elseif object.id == 5321 then
    local stage = 2
    local target1 = "the Leading Player"
elseif object.id == 5322 then
    local stage = 3
    local target1 = "the Chaos"
elseif object.id == 5323 then
    local stage = 4
    local target1 = "whatever waits at the end of the shaman's vision quest"
elseif object.id == 5324 then
    local stage = 5
    local target1 = "the Fangs of Yeenoghu"
elseif object.id == 5325 then
    local stage = 6
    local target1 = "the fire elemental lord"
elseif object.id == 5326 then
    local stage = 7
    local target1 = "an acolyte of Betrayal"
elseif object.id == 5327 then
    local stage = 8
    local target1 = "for Cyprianum the Reaper"
elseif object.id == 5328 then
    local stage = 9
    local target1 = "a Chaos Demon"
elseif object.id == 5329 then
    local stage = 10
    local target1 = "the Norhamen"
end
if actor:get_quest_stage("elemental_chaos") == "stage" and actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    local anti = "Anti-Paladin"
    wait(2)
    world.destroy(object)
    self:command("bow")
    actor:send(tostring(self.name) .. " says, 'Harmony follows your actions.'")
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
    actor:set_quest_var("elemental_chaos", "target1", 0)
    actor:set_quest_var("elemental_chaos", "bounty", 0)
    wait(2)
    if stage < 10 then
        actor:advance_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'I will investigate further.  Return later and I shall tell you my findings.'")
    else
        actor:complete_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'You have done Balance a great service.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'May this ring ever remind you to ever walk the Way.'")
        self.room:spawn_object(124, 6)
        self:command("give ring " .. tostring(actor))
    end
    if string.find(actor.class, "Monk") and actor:get_quest_stage("monk_vision") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You are ready to begin your own path to <b:cyan>[Enlightenment]</>.'")
        self.room:spawn_object(3, 90)
        self:command("give vision " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'These markings represent your voyage.'")
        actor:start_quest("monk_vision")
        wait(2)
        if actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Come back with that vision after you reach level 10.  We can discuss your voyage toward enlightenment then.'")
        end
    end
elseif actor:get_quest_stage("elemental_chaos") > stage then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the mission.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You already accomplished this!'")
elseif actor:get_quest_stage("elemental_chaos") < stage then
    wait(2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the mission!")
    world.destroy(object)
elseif actor:get_quest_var("elemental_chaos:bounty") == "running" then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses the mission.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You have to complete your mission first!")
    if stage == 5 then
        actor:send(tostring(target1) .. " are still out there.'")
    else
        actor:send(tostring(target1) .. " is still out there.'")
    end
end
return _return_value