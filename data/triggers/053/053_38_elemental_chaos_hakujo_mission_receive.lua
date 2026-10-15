-- Trigger: Elemental Chaos Hakujo mission receive
-- Zone: 53, ID: 38
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
-- TODO(parity): branch-scoped `stage`, `target1`, `expmod`, `expcap`,
-- `bonus`, `anti`. `actor:get_quest_stage(...) == "stage"` string
-- compare. `person.class` (never assigned in DG) now reads `actor.class`. `%anti%`
-- should be `anti` variable. Legacy 5-digit ids. Full rewrite from DG
-- #5338.
--
-- Original DG Script: #5338

-- Converted from DG Script #5338: Elemental Chaos Hakujo mission receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- mission targets here
local stage, target1
if (object.zone_id == 53 and object.id == 20) then
    stage = 1
    target1 = "an imp"
elseif (object.zone_id == 53 and object.id == 21) then
    stage = 2
    target1 = "the Leading Player"
elseif (object.zone_id == 53 and object.id == 22) then
    stage = 3
    target1 = "the Chaos"
elseif (object.zone_id == 53 and object.id == 23) then
    stage = 4
    target1 = "whatever waits at the end of the shaman's vision quest"
elseif (object.zone_id == 53 and object.id == 24) then
    stage = 5
    target1 = "the Fangs of Yeenoghu"
elseif (object.zone_id == 53 and object.id == 25) then
    stage = 6
    target1 = "the fire elemental lord"
elseif (object.zone_id == 53 and object.id == 26) then
    stage = 7
    target1 = "an acolyte of Betrayal"
elseif (object.zone_id == 53 and object.id == 27) then
    stage = 8
    target1 = "for Cyprianum the Reaper"
elseif (object.zone_id == 53 and object.id == 28) then
    stage = 9
    target1 = "a Chaos Demon"
elseif (object.zone_id == 53 and object.id == 29) then
    stage = 10
    target1 = "the Norhamen"
end
if actor:get_quest_stage("elemental_chaos") == "stage" and actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    local anti = "Anti-Paladin"
    wait(0.2)
    world.destroy(object)
    self:command("bow")
    actor:send(tostring(self.name) .. " says, 'Harmony follows your actions.'")
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
    -- switch on actor.class
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = (expmod + (expmod / 10))
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = (expmod + ((expmod * 2) / 15))
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = (expmod + (expmod / 5))
    elseif actor.class == "necromancer" or actor.class == "monk" then
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
    actor:set_quest_var("elemental_chaos", "target1", 0)
    actor:set_quest_var("elemental_chaos", "bounty", 0)
    wait(0.2)
    if stage < 10 then
        actor:advance_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'I will investigate further.  Return later and I shall tell you my findings.'")
    else
        actor:complete_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'You have done Balance a great service.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'May this ring ever remind you to ever walk the Way.'")
        self.room:spawn_object(123, 106)
        self:command("give ring " .. tostring(actor))
    end
    if string.find(actor.class, "monk") and actor:get_quest_stage("monk_vision") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You are ready to begin your own path to <b:cyan>[Enlightenment]</>.'")
        self.room:spawn_object(2, 190)
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
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the mission.")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'You already accomplished this!'")
elseif actor:get_quest_stage("elemental_chaos") < stage then
    wait(0.2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the mission!")
    world.destroy(object)
elseif actor:get_quest_var("elemental_chaos:bounty") == "running" then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses the mission.")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'You have to complete your mission first!")
    if stage == 5 then
        actor:send(tostring(target1) .. " are still out there.'")
    else
        actor:send(tostring(target1) .. " is still out there.'")
    end
end
return _return_value