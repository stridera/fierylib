-- Trigger: summon_dragon
-- Zone: 188, ID: 91
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #18891

-- Converted from DG Script #18891: summon_dragon
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: summon
if not (cmd == "summon") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "su" then
    _return_value = false
    return _return_value
end
local last_summon = actor:get_quest_var("quest_items:dragonhelm_time")
local now = (((((time.year * 16) + time.month) * 35) + time.day) * 24) + time.hour
if last_summon then
    if now - last_summon >= 168 then
        local can_summon = "yes"
    else
        actor:send("You may only summon one mount per week!")
    end
else
    local can_summon = "yes"
end
if can_summon == "yes" then
    -- The knight doesn't have a mount yet, allow them to get one
    if actor.class == "Paladin" then
        -- Knight is a paladin, give him/her a golden dragon
        self.room:spawn_mobile(188, 90)
        self.room:send_except(actor, "A brilliant golden dragon flies in from nowhere, and nuzzles " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A brilliant golden dragon answers your summons.")
        local summoned = "yes"
    elseif string.find(actor.class, "Anti") then
        -- Knight is an anti-paladin, give him/her a black dragon
        self.room:spawn_mobile(188, 91)
        self.room:send_except(actor, "A dusky black dragon flies in, seemingly from nowhere, and sits by " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A dusky black dragon answers your summons.")
        local summoned = "yes"
    else
        actor:send("You begin calling for a mount...but nothing happens.")
        self.room:send_except(actor, tostring(actor.name) .. " whistles loudly.")
    end
    -- Saddle up the dragon mount
    if summoned then
        self.room:find_actor("dragon-mount"):follow(actor.name)
        self.room:spawn_mobile(188, 92)
        self.room:find_actor("dragonsquire"):spawn_object(188, 92)
        self.room:find_actor("dragonsquire"):command("give dragonsaddle dragon-mount")
        self.room:find_actor("dragon-mount"):command("wear dragonsaddle")
        world.destroy(self.room:find_object("dragonsquire"))
        -- Timestamp
        actor.name:set_quest_var("quest_items", "dragonhelm_time", now)
    end
end
return _return_value