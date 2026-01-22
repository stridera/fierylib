-- Trigger: megalith_quest_mother_act_kneel_rewards
-- Zone: 123, ID: 23
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--   Large script: 5001 chars
--
-- Original DG Script: #12323

-- Converted from DG Script #12323: megalith_quest_mother_act_kneel_rewards
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: kneel
if not (cmd == "kneel") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
-- switch on cmd
if cmd == "k" then
    return _return_value
end
wait(2)
if actor:get_quest_var("megalith_quest:bad1") == 1 then
    local bad1 = 1
end
if actor:get_quest_var("megalith_quest:bad2") == 1 then
    local bad2 = 1
end
if actor:get_quest_var("megalith_quest:bad3") == 1 then
    local bad3 = 1
end
if actor:get_quest_stage("megalith_quest") == 5 then
    local total = bad1 + bad2 + bad3
    if string.find(total, "0") then
        actor:send(tostring(self.name) .. " gently leans forward and kisses your brow.")
        self.room:send_except(actor, tostring(self.name) .. " gently leans forward and kisses " .. tostring(actor.name) .. "'s brow.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you the gifts of stars.  May their light")
        self.room:send("</>guide you the rest of your days.'")
        self.room:spawn_object(123, 98)
        self.room:spawn_object(123, 99)
        self:command("give belt-stars " .. tostring(actor))
        self:command("give starseed " .. tostring(actor))
        local gem = 0
        while gem < 3 do
            local drop = random(1, 11) + 55736
            self.room:spawn_object(vnum_to_zone(drop), vnum_to_local(drop))
            local gem = gem + 1
        end
        self:command("give all.gem " .. tostring(actor.name))
    elseif total > 0 then
        actor:send(tostring(self.name) .. " places her hand on your shoulder.")
        self.room:send_except(actor, tostring(self.name) .. " places her hand on " .. tostring(actor.name) .. "'s shoulder.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you a gift of stars.  May its light")
        self.room:send("</>guide you the rest of your days.'")
        local random = random(1, 2)
        if random == 1 then
            self.room:spawn_object(123, 98)
        elseif random == 2 then
            self.room:spawn_object(123, 99)
        end
        local gem = 0
        while gem < 3 do
            local drop = random(1, 11) + 55736
            self.room:spawn_object(vnum_to_zone(drop), vnum_to_local(drop))
            local gem = gem + 1
        end
        self:command("give all " .. tostring(actor.name))
        wait(4)
        self:command("bow " .. tostring(actor.name))
    end
    -- 
    -- Clear all the Bads, just in case
    -- 
    local item = 1
    while item <= 5 do
        actor.name:set_quest_var("megalith_quest", "bad%item%", 0)
        bad[item] = nil
        local item = item + 1
    end
    actor.name:complete_quest("megalith_quest")
    -- 
    -- Set X to the level of the award - code does not run without it
    -- 
    if actor.level < 70 then
        local expcap = actor.level
    else
        local expcap = 70
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
    -- 
    -- Adjust exp award by class so all classes receive the same proportionate amount
    -- 
    -- switch on actor.class
    if actor.class == "Warrior" or actor.class == "Berserker" then
        -- 
        -- 110% of standard
        -- 
        local expmod = (expmod + (expmod / 10))
    elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
        -- 
        -- 115% of standard
        -- 
        local expmod = (expmod + ((expmod * 2) / 15)
    elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
        -- 
        -- 120% of standard
        -- 
        local expmod = (expmod + (expmod / 5))
    elseif actor.class == "Necromancer" or actor.class == "Monk" then
        -- 
        -- 130% of standard
        -- 
        local expmod = (expmod + (expmod * 2) / 5)
    else
        local expmod = expmod
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 10 do
        -- 
        -- Xexp must be replaced by mexp, oexp, or wexp for this code to work
        -- Pick depending on what is running the trigger
        -- 
        actor:award_exp(setexp)
        local loop = loop + 1
    end
end
return _return_value