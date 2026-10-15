-- Trigger: Honus order receive
-- Zone: 53, ID: 23
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
-- TODO(parity): `stage`, `treasure1`, `expmod`, `expcap`, `bonus`, `anti`
-- are all branch-scoped `local` decls — referenced after the if/elseif
-- chain. `actor:get_quest_stage(...) == "stage"` is a string compare.
-- `person.class` (never assigned in DG) now reads `actor.class`. `%anti%` should be
-- the variable `anti`. Legacy 5-digit object ids and reward 123,117 etc.
-- Full rewrite from DG #5323.
--
-- Original DG Script: #5323

-- Converted from DG Script #5323: Honus order receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt orders here
local stage, treasure1
if (object.zone_id == 53 and object.id == 10) then
    stage = 1
    treasure1 = "a singing chain"
elseif (object.zone_id == 53 and object.id == 11) then
    stage = 2
    treasure1 = "a fire ring"
elseif (object.zone_id == 53 and object.id == 12) then
    stage = 3
    treasure1 = "a sandstone ring"
elseif (object.zone_id == 53 and object.id == 13) then
    stage = 4
    treasure1 = "a crimson-tinged electrum hoop"
elseif (object.zone_id == 53 and object.id == 14) then
    stage = 5
    treasure1 = "a Rainbow Shell"
elseif (object.zone_id == 53 and object.id == 15) then
    stage = 6
    treasure1 = "the Stormshield"
elseif (object.zone_id == 53 and object.id == 16) then
    stage = 7
    treasure1 = "the Snow Leopard Cloak"
elseif (object.zone_id == 53 and object.id == 17) then
    stage = 8
    treasure1 = "a coiled rope ladder"
elseif (object.zone_id == 53 and object.id == 18) then
    stage = 9
    treasure1 = "a glowing phoenix feather"
elseif (object.zone_id == 53 and object.id == 19) then
    stage = 10
    treasure1 = "a piece of sleet armor"
end
if actor:get_quest_stage("treasure_hunter") == "stage" and actor:get_quest_var("treasure_hunter:hunt") == "returned" then
    local anti = "Anti-Paladin"
    wait(0.2)
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
    actor:set_quest_var("treasure_hunter", "treasure1", 0)
    actor:set_quest_var("treasure_hunter", "hunt", 0)
    wait(0.2)
    if stage < 10 then
        actor:advance_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
    else
        actor:complete_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest treasure hunters in the realm!'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Here, take this bracelet as payment for all you've done.  Wear this proudly.'")
        self.room:spawn_object(123, 117)
        self:command("give bracelet " .. tostring(actor))
    end
    if (string.find(actor.class, "rogue") or string.find(actor.class, "thief") or string.find(actor.class, "bard")) and actor:get_quest_stage("rogue_cloak") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
        self.room:spawn_object(2, 180)
        self:command("give cloak " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Cloaks like these show off your rank in the various cloak and dagger guilds.'")
        actor:start_quest("rogue_cloak")
        wait(2)
        if actor.level > 9 then
            actor:send(tostring(self.name) .. " says, 'This puts you in line for a <b:cyan>[promotion]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Come back with that cloak after you reach level 10.  We can discuss a promotion then.'")
        end
    end
elseif actor:get_quest_stage("treasure_hunter") > stage then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the order.")
    actor:send(tostring(self.name) .. " says, 'You already stole - er, recovered this treasure!'")
    return false  -- legacy return 0: the giver keeps the item
elseif actor:get_quest_stage("treasure_hunter") < stage then
    wait(0.2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the order!")
    world.destroy(object)
elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
    self.room:send(tostring(self.name) .. " refuses the order.")
    actor:send(tostring(self.name) .. " says, 'You have to find the treasure still!  " .. tostring(treasure1) .. " is still out there.")
    return false  -- legacy return 0: the giver keeps the item
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    self.room:send(tostring(self.name) .. " refuses the order.")
    actor:send(tostring(self.name) .. " says, 'You have to give me the treasure first!  You still have " .. tostring(treasure1) .. " in your possession.'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value