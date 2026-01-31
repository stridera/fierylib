-- Trigger: fierytag_bat_capturetheflag
-- Zone: 188, ID: 97
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 5218 chars
--
-- Original DG Script: #18897

-- Converted from DG Script #18897: fierytag_bat_capturetheflag
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: tag
if not (cmd == "tag") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "t" or cmd == "ta" then
    _return_value = false
    return _return_value
end
local zone_a_start = 3000
local zone_a_end = 3199
local zone_a_jail_zone, zone_a_jail_local = 30, 9
local zone_a_home_zone, zone_a_home_local = 30, 54
local zone_b_start = 8000
local zone_b_end = 8199
local zone_b_jail_zone, zone_b_jail_local = 81, 33
local zone_b_home_zone, zone_b_home_local = 80, 49
local zone_c_start = 3500
local zone_c_end = 3699
local zone_c_jail_zone, zone_c_jail_local = 35, 14
local zone_c_home_zone, zone_c_home_local = 35, 0
if (arg == "self") or (actor.name == arg.name) then
    actor:send("Now that seems a little pointless, doesn't it?")
elseif actor.room ~= arg.room then
    actor:send("Tag who? They don't seem to be here!")
elseif arg.id ~= -1 then
    actor:send("You can only tag players!")
elseif arg.level > 99 then
    actor:send("You cannot tag immortals!")
else
    if actor.gender == "Male" then
        local actor_home_zone, actor_home_local = zone_a_home_zone, zone_a_home_local
        local actor_jail_zone, actor_jail_local = zone_a_jail_zone, zone_a_jail_local
        if actor.room >= zone_a_start then
            if actor.room <= zone_a_end then
                local actor_at_home = "yes"
            end
        end
    elseif actor.gender == "Female" then
        local actor_home_zone, actor_home_local = zone_b_home_zone, zone_b_home_local
        local actor_jail_zone, actor_jail_local = zone_b_jail_zone, zone_b_jail_local
        if actor.room >= zone_b_start then
            if actor.room <= zone_b_end then
                local actor_at_home = "yes"
            end
        end
    elseif actor.gender == "Neutral" then
        local actor_home_zone, actor_home_local = zone_c_home_zone, zone_c_home_local
        local actor_jail_zone, actor_jail_local = zone_c_jail_zone, zone_c_jail_local
        if actor.room >= zone_c_start then
            if actor.room <= zone_c_end then
                local actor_at_home = "yes"
            end
        end
    end
    if arg.gender == actor.gender then
        local arg_same_team = "yes"
    end
    if (arg.room == "zone_a_jail") or (arg.room == "zone_b_jail") or (arg.room == "zone_c_jail") then
        local arg_in_jail = "yes"
    end
    if actor.room == "actor_jail" then
        if arg_same_team == "yes" then
            -- Tagging teammate in opponent jail, rescue them
            arg:teleport(get_room(actor_home_zone, actor_home_local))
            arg:send(tostring(actor.name) .. " tags you, returning you to home!")
            self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. ", returning " .. tostring(arg.object) .. " to home!")
            actor:send("You tag " .. tostring(arg.name) .. ", returning " .. tostring(arg.object) .. " to home!")
            actor:teleport(get_room(actor_home_zone, actor_home_local))
            arg:command("look")
            actor:command("look")
        else
            actor:send("That's no good.  " .. tostring(arg.name) .. " is already in your jail.")
        end
    elseif actor_at_home == "yes" then
        if arg_same_team == "yes" then
            -- Tagging teammate in home zone, do nothing
            actor:send("But you're in your own zone!  " .. tostring(arg.name) .. " is on your team!")
        else
            -- Tagging opponent in home zone, teleport opponent to jail
            arg:command("remove fiery-tag-bat")
            arg:command("junk fiery-tag-bat")
            arg:teleport(get_room(actor_jail_zone, actor_jail_local))
            self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. "!  To jail " .. tostring(arg.name) .. " goes!")
            actor:send("You tag " .. tostring(arg.name) .. ", sending " .. tostring(arg.object) .. " to jail!")
            arg:send(tostring(actor.name) .. " tags you, sending you to jail!")
            arg:command("look")
        end
    elseif arg_same_team == "yes" then
        if arg_in_jail == "yes" then
            -- Tagging teammate in opponent jail, rescue them
            self.room:spawn_object(188, 97)
            arg:heal(10)
            arg:command("wake")
            arg:command("get fiery-tag-bat")
            arg:teleport(get_room(actor_home_zone, actor_home_local))
            arg:send(tostring(actor.name) .. " tags you, rescuing you from your imprisonment!")
            self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. ", returning both of them to their zone!")
            actor:send("You tag " .. tostring(arg.name) .. ", rescuing " .. tostring(arg.object) .. " from " .. tostring(arg.possessive) .. " imprisonment!")
            actor:teleport(get_room(actor_home_zone, actor_home_local))
            arg:command("look")
            actor:command("look")
        else
            -- Tagging teammate in opponent zone, but not jail, do nothing
            actor:send(tostring(arg.name) .. " doesn't need rescuing right now.")
        end
    else
        -- Tagging opponent in opponent zone, do nothing
        actor:send("No point in tagging " .. tostring(arg.object) .. " if you're not in your zone.")
    end
end
return _return_value