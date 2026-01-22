-- Trigger: Honus order receive
-- Zone: 53, ID: 23
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--   Large script: 6015 chars
--
-- Original DG Script: #5323

-- Converted from DG Script #5323: Honus order receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt orders here
if object.id == 5310 then
    local stage = 1
    local treasure1 = "a singing chain"
elseif object.id == 5311 then
    local stage = 2
    local treasure1 = "a fire ring"
elseif object.id == 5312 then
    local stage = 3
    local treasure1 = "a sandstone ring"
elseif object.id == 5313 then
    local stage = 4
    local treasure1 = "a crimson-tinged electrum hoop"
elseif object.id == 5314 then
    local stage = 5
    local treasure1 = "a Rainbow Shell"
elseif object.id == 5315 then
    local stage = 6
    local treasure1 = "the Stormshield"
elseif object.id == 5316 then
    local stage = 7
    local treasure1 = "the Snow Leopard Cloak"
elseif object.id == 5317 then
    local stage = 8
    local treasure1 = "a coiled rope ladder"
elseif object.id == 5318 then
    local stage = 9
    local treasure1 = "a glowing phoenix feather"
elseif object.id == 5319 then
    local stage = 10
    local treasure1 = "a piece of sleet armor"
end
if actor:get_quest_stage("treasure_hunter") == "stage" and actor:get_quest_var("treasure_hunter:hunt") == "returned" then
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
    actor:set_quest_var("treasure_hunter", "treasure1", 0)
    actor:set_quest_var("treasure_hunter", "hunt", 0)
    wait(2)
    if stage < 10 then
        actor:advance_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
    else
        actor:complete_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest treasure hunters in the realm!'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Here, take this bracelet as payment for all you've done.  Wear this proudly.'")
        self.room:spawn_object(124, 17)
        self:command("give bracelet " .. tostring(actor))
    end
    if (string.find(actor.class, "Rogue") or string.find(actor.class, "Thief") or string.find(actor.class, "Bard")) and actor:get_quest_stage("rogue_cloak") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
        self.room:spawn_object(3, 80)
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
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the order.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You already stole - er, recovered this treasure!'")
elseif actor:get_quest_stage("treasure_hunter") < stage then
    wait(2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the order!")
    world.destroy(object)
elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses the order.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You have to find the treasure still!  " .. tostring(treasure1) .. " is still out there.")
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses the order.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You have to give me the treasure first!  You still have " .. tostring(treasure1) .. " in your possession.'")
end
return _return_value