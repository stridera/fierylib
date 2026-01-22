-- Trigger: Myst_quest_reward
-- Zone: 30, ID: 30
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #3030

-- Converted from DG Script #3030: Myst_quest_reward
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(1)
self:destroy_item("shard")
-- Create a random number by which to judge prize table off of.
local rnd = random(1, 100)
if rnd >= 90 then
    self.room:spawn_object(4, 1)
elseif rnd < 90 and rnd >= 70 then
    self.room:spawn_object(30, 40)
elseif rnd < 70 and rnd >= 30 then
    -- switch on random(1, 19)
    if random(1, 19) == 1 then
        -- cure crit x3
        self.room:spawn_object(83, 42)
    elseif random(1, 19) == 2 then
        -- strength
        self.room:spawn_object(32, 74)
    elseif random(1, 19) == 3 then
        -- wisdom
        self.room:spawn_object(32, 78)
    elseif random(1, 19) == 4 then
        -- monk fire
        self.room:spawn_object(32, 49)
    elseif random(1, 19) == 5 then
        -- monk acid
        self.room:spawn_object(32, 58)
    elseif random(1, 19) == 6 then
        -- bless, remove curse, cure serious
        self.room:spawn_object(117, 1)
    elseif random(1, 19) == 7 then
        -- prot evil, enhance con, remove poison
        self.room:spawn_object(117, 2)
    elseif random(1, 19) == 8 then
        -- prot evil, enhance wis
        self.room:spawn_object(178, 8)
    elseif random(1, 19) == 9 then
        -- prot cold, monk ice
        self.room:spawn_object(32, 41)
    elseif random(1, 19) == 10 then
        -- monk lightning
        self.room:spawn_object(32, 55)
    elseif random(1, 19) == 11 then
        -- monk ice
        self.room:spawn_object(32, 52)
    elseif random(1, 19) == 12 then
        -- prot cold
        self.room:spawn_object(32, 65)
    elseif random(1, 19) == 13 then
        -- prot fire
        self.room:spawn_object(32, 62)
    elseif random(1, 19) == 14 then
        -- prot air
        self.room:spawn_object(32, 68)
    elseif random(1, 19) == 15 then
        -- prot earth
        self.room:spawn_object(32, 71)
    elseif random(1, 19) == 16 then
        -- intelligence
        self.room:spawn_object(32, 82)
    elseif random(1, 19) == 17 then
        -- charisma
        self.room:spawn_object(32, 86)
    elseif random(1, 19) == 18 then
        -- constitution
        self.room:spawn_object(32, 90)
    elseif random(1, 19) == 19 then
        -- dexterity
        self.room:spawn_object(32, 94)
    else
        self:say("This quest reward has a broken potion random chance, let a god know.")
    end
elseif rnd < 30 then
    self.room:spawn_object(30, 41)
else
    self:say("The reward for this quest is broken, contact a god and let them know.")
end
self:shout("Hark all and listen, " .. tostring(actor.name) .. " has fended off a great evil for our fair town!")
wait(1)
self:say("Here, " .. tostring(actor.name) .. " you have earned this as a reward.")
wait(1)
self:command("give all " .. tostring(actor.name))
if not actor:get_has_completed("mystwatch_quest") and actor:get_quest_var("mystwatch_quest:step") == "complete" then
    actor.name:complete_quest("mystwatch_quest")
    if actor.level < 50 then
        local expcap = actor.level
    else
        local expcap = 50
    end
    local expmod = 0
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
    -- switch on actor.class
    if actor.class == "Warrior" or actor.class == "Berserker" then
        local expmod = (expmod + (expmod / 10))
    elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
        local expmod = (expmod + ((expmod * 2) / 15))
    elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
        local expmod = (expmod + (expmod / 5))
    elseif actor.class == "Necromancer" or actor.class == "Monk" then
        local expmod = (expmod + ((expmod * 2) / 5))
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
end
if world.count_mobiles("16007") < 1 then
    get_room(160, 64):at(function()
        self.room:spawn_mobile(160, 7)
    end)
end