-- Trigger: ctf_armband_tag
-- Zone: 188, ID: 80
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 14 if statements
--   Large script: 8043 chars
--
-- Original DG Script: #18880

-- Converted from DG Script #18880: ctf_armband_tag
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: tag
if not (cmd == "tag") then
    return true  -- Not our command
end
-- *** Set vnum variables ****
-- Mobiles
local referee = 18880
-- Objects
local vnum_a = 18880
local vnum_b = 18881
local flag_a_zone, flag_a_local = 188, 82
local flag_b_zone, flag_b_local = 188, 83
-- Rooms
local zone_a_start = 3500
local zone_a_end = 3599
local jail_a_zone, jail_a_local = 188, 80
local home_a_zone, home_a_local = 35, 0
local flag_room_a_zone, flag_room_a_local = 35, 0
local zone_b_start = 8000
local zone_b_end = 8199
local jail_b_zone, jail_b_local = 188, 81
local home_b_zone, home_b_local = 80, 25
local flag_room_b_zone, flag_room_b_local = 80, 50
-- Player has been forced to deactivate their armband
if arg == "DeactivateArmband" then
    local inactive = "yes"
    globals.inactive = globals.inactive or true
    -- Player has been forced to reactivate their armband
elseif arg == "ReactivateArmband" then
    local inactive = "no"
    globals.inactive = globals.inactive or true
    -- Player is wearing an inactive armband
elseif inactive == "yes" then
    actor:send("Sorry, you can't tag anyone right now!")
    -- Player tries to tag self
elseif (arg == "self") or (actor.name == arg.name) then
    actor:send("There's really no point to that, now is there?")
    -- Player tries to tag someone who isn't in room or doesn't exist
elseif arg.room ~= actor.room then
    actor:send("Tag whom?  They're not here!")
    -- Player tries to tag immortal
elseif arg.level > 99 then
    actor:send("It's not very nice to tag immortals.")
    -- Player is holding the flag
elseif (actor.wearing[flag_a]) or (actor.wearing[flag_b]) then
    actor:send("You cannot tag someone while holding the flag!")
    -- Player tries to tag player or referee mob
elseif (arg.id == -1) or (arg.id == "referee") then
    -- Player tries to tag someone on team A
    if arg.wearing[vnum_a] then
        local arg_team = vnum_a
        -- Player tries to tag someone on team B
    elseif arg.wearing[vnum_b] then
        local arg_team = vnum_b
        -- Player tries to tag someone who isn't playing
    else
        actor:send(tostring(arg.name) .. " doesn't seem to be playing.")
    end
    -- Player tries to tag someone who is playing
    if arg_team then
        -- Player is on team A
        if self.id == "vnum_a" then
            local actor_home_zone, actor_home_local = home_a_zone, home_a_local
            local actor_jail_zone, actor_jail_local = jail_a_zone, jail_a_local
            local actor_flag_room_zone, actor_flag_room_local = flag_room_a_zone, flag_room_a_local
            local actor_flag_zone, actor_flag_local = flag_a_zone, flag_a_local
            -- Player is in home zone
            if (actor.room >= zone_a_start) and (actor.room <= zone_a_end) then
                local at_home = "yes"
            end
            -- Player is on team B
        elseif self.id == "vnum_b" then
            local actor_home_zone, actor_home_local = home_b_zone, home_b_local
            local actor_jail_zone, actor_jail_local = jail_b_zone, jail_b_local
            local actor_flag_room_zone, actor_flag_room_local = flag_room_b_zone, flag_room_b_local
            local actor_flag_zone, actor_flag_local = flag_b_zone, flag_b_local
            -- Player is in home zone
            if (actor.room >= zone_b_start) and (actor.room <= zone_b_end) then
                local at_home = "yes"
            end
        end
        -- Player tries to tag someone in jail
        if (actor.room == "jail_a") or (actor.room == "jail_b") then
            local in_jail = "yes"
        end
        -- Player tries to tag someone on the same team
        if arg_team == self.id then
            -- Player tags teammate in jail (Return both to team home room)
            if in_jail == "yes" then
                arg:teleport(get_room(actor_home_zone, actor_home_local))
                arg:send(tostring(actor.name) .. " tags you, rescuing you from jail!")
                self.room:send_except(arg, tostring(actor.name) .. " appears in a bright flash of light!")
                self.room:send_except(arg, tostring(arg.name) .. " appears in a bright flash of light!")
                self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. ", rescuing " .. tostring(arg.object) .. " from jail!")
                actor:send("You tag " .. tostring(arg.name) .. ", rescuing " .. tostring(arg.object) .. " from jail!")
                actor:teleport(get_room(actor_home_zone, actor_home_local))
                arg:command("tag ReactivateArmband")
                actor:command("look")
                arg:command("look")
                -- Player tries to tag teammate in home zone
            elseif at_home == "yes" then
                actor:send(tostring(arg.name) .. " doesn't need saving in your own zone!")
                -- Player tries to tag teammate not in home zone, but not in jail
            else
                actor:send(tostring(arg.name) .. " doesn't need saving right now!")
            end
            -- Player tries to tag someone on an enemy team
        else
            -- Player tries to tag enemy in jail
            if in_jail == "yes" then
                -- Player tries to tag enemy in player's jail
                if actor.room == "actor_jail" then
                    actor:send(tostring(arg.name) .. " is already in your jail!")
                    -- Player tags enemy in enemy's jail (Send enemy to jail and player to home)
                else
                    arg:teleport(get_room(actor_jail_zone, actor_jail_local))
                    arg:send(tostring(actor.name) .. " tags you, banishing you for jail-guarding!")
                    self.room:send_except(arg, tostring(arg.name) .. " appears in a bright flash of light!")
                    self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. ", banishing " .. tostring(arg.object) .. " for jail-guarding!")
                    actor:send("You tag " .. tostring(arg.name) .. ", banishing " .. tostring(arg.object) .. " for jail-guarding!")
                    actor:teleport(get_room(actor_home_zone, actor_home_local))
                    self.room:send_except(actor, tostring(actor.name) .. " appears in a bright flash of light!")
                    arg:command("tag DeactivateArmband")
                    actor:command("look")
                    arg:command("look")
                end
                -- Player tries to tag enemy in player's flag room
            elseif actor.room == "actor_flag_room" then
                actor:send("You can't tag " .. tostring(arg.name) .. " in your flag room!")
                -- Player tags enemy in player's zone (Send enemy to player's jail)
            elseif at_home == "yes" then
                arg:send(tostring(actor.name) .. " tags you, sending you to " .. tostring(actor.object) .. " jail!")
                arg:teleport(get_room(actor_jail_zone, actor_jail_local))
                self.room:send_except(arg, tostring(arg.name) .. " appears in a bright flash of light!")
                self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. ", sending " .. tostring(arg.object) .. " to jail!")
                actor:send("You tag " .. tostring(arg.name) .. ", sending " .. tostring(arg.object) .. " to your jail!")
                arg:command("tag DeactivateArmband")
                arg:command("look")
                -- Player tries to tag enemy outside of player's zone
            else
                actor:send("Tagging " .. tostring(arg.name) .. " has no effect outside your zone!")
            end
            -- Player tags enemy holding flag
            if (arg.wearing[flag_a]) or (arg.wearing[flag_b]) then
                local actor_room_zone = actor.room.zone_id
                local actor_room_local = actor.room.local_id
                arg:command("remove ctf-flag")
                actor:teleport(get_room(actor_flag_room_zone, actor_flag_room_local))
                self.room:spawn_object(actor_flag_zone, actor_flag_local)
                actor:teleport(get_room(actor_room_zone, actor_room_local))
            end
        end
    end
    -- Player tries to tag other mob
else
    actor:send("You can only tag players!")
end