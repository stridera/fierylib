-- Trigger: megalith_quest_mother_act_kneel_rewards
-- Zone: 123, ID: 23
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12323

-- Converted from DG Script #12323: megalith_quest_mother_act_kneel_rewards
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: kneel
if not (cmd == "kneel") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if cmd == "k" then
    return _return_value
end
wait(2)
local bad1 = (actor:get_quest_var("megalith_quest:bad1") == 1) and 1 or 0
local bad2 = (actor:get_quest_var("megalith_quest:bad2") == 1) and 1 or 0
local bad3 = (actor:get_quest_var("megalith_quest:bad3") == 1) and 1 or 0
if actor:get_quest_stage("megalith_quest") == 5 then
    local total = bad1 + bad2 + bad3
    if total == 0 then
        actor:send(tostring(self.name) .. " gently leans forward and kisses your brow.")
        self.room:send_except(actor, tostring(self.name) .. " gently leans forward and kisses " .. tostring(actor.name) .. "'s brow.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you the gifts of stars.  May their light")
        self.room:send("</>guide you the rest of your days.'")
        self.room:spawn_object(123, 98)
        self.room:spawn_object(123, 99)
        self:command("give belt-stars " .. tostring(actor.name))
        self:command("give starseed " .. tostring(actor.name))
        local gem = 0
        while gem < 3 do
            -- TODO(parity): the original drop pool used legacy 5-digit
            -- vnums 55736..55747. After the (zone, local_id) split, this
            -- gem set should live at zone 557 ids 36..47. Verify.
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all.gem " .. tostring(actor.name))
    elseif total > 0 then
        actor:send(tostring(self.name) .. " places her hand on your shoulder.")
        self.room:send_except(actor, tostring(self.name) .. " places her hand on " .. tostring(actor.name) .. "'s shoulder.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you a gift of stars.  May its light")
        self.room:send("</>guide you the rest of your days.'")
        local pick = random(1, 2)
        if pick == 1 then
            self.room:spawn_object(123, 98)
        elseif pick == 2 then
            self.room:spawn_object(123, 99)
        end
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all " .. tostring(actor.name))
        wait(4)
        self:command("bow " .. tostring(actor.name))
    end
    -- Clear all the Bads, just in case.
    for slot = 1, 5 do
        actor:set_quest_var("megalith_quest", "bad" .. tostring(slot), 0)
    end
    actor:complete_quest("megalith_quest")
    -- Set X to the level of the award.
    local expcap
    if actor.level < 70 then
        expcap = actor.level
    else
        expcap = 70
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
    -- Adjust exp award by class so all classes receive the same proportionate amount.
    if actor.class == "Warrior" or actor.class == "Berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif actor.class == "Necromancer" or actor.class == "Monk" then
        -- 130% of standard
        expmod = expmod + (expmod * 2) / 5
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 10 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
end
return _return_value
