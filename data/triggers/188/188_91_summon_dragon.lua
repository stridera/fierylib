-- Trigger: summon_dragon
-- Zone: 188, ID: 91
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
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
    _return_value = true
    return _return_value
end
local last_summon = actor:get_quest_var("quest_items:dragonhelm_time")
-- timestamp() is monotonic seconds; 168 hours == 604800 seconds.
local now = timestamp()
local can_summon = false
if last_summon then
    if now - last_summon >= 604800 then
        can_summon = true
    else
        actor:send("You may only summon one mount per week!")
    end
else
    can_summon = true
end
if can_summon then
    local summoned
    -- The knight doesn't have a mount yet, allow them to get one
    if actor.class == "Paladin" then
        -- Knight is a paladin, give him/her a golden dragon
        self.room:spawn_mobile(188, 90)
        self.room:send_except(actor, "A brilliant golden dragon flies in from nowhere, and nuzzles " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A brilliant golden dragon answers your summons.")
        summoned = "yes"
    elseif string.find(actor.class, "Anti") then
        -- Knight is an anti-paladin, give him/her a black dragon
        self.room:spawn_mobile(188, 91)
        self.room:send_except(actor, "A dusky black dragon flies in, seemingly from nowhere, and sits by " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A dusky black dragon answers your summons.")
        summoned = "yes"
    else
        actor:send("You begin calling for a mount...but nothing happens.")
        self.room:send_except(actor, tostring(actor.name) .. " whistles loudly.")
    end
    -- Saddle up the dragon mount
    if summoned then
        local mount = self.room:find_actor("dragon-mount")
        if mount then mount:follow(actor.name) end
        self.room:spawn_mobile(188, 92)
        local squire = self.room:find_actor("dragonsquire")
        if squire then
            squire:spawn_object(188, 92)
            squire:command("give dragonsaddle dragon-mount")
            world.destroy(squire)
        end
        if mount then mount:command("wear dragonsaddle") end
        -- Timestamp the per-week cooldown
        actor:set_quest_var("quest_items", "dragonhelm_time", now)
    end
end
return _return_value