-- Trigger: ctf_armband_tag
-- Zone: 188, ID: 80
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW (parses, but several literal-vs-variable comparisons remain; see TODOs)
--
-- Original DG Script: #18880
-- Converted from DG Script #18880: ctf_armband_tag
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%
--
-- TODO(parity): `self.id == "team_a_id"` etc. compare a numeric id against a
-- string literal — these branches never fire today. Replace with
-- `self.local_id == 80` / `self.local_id == 81` (or whatever the team armband
-- ids are). Same for `actor.room == "jail_a"` comparisons.
-- TODO(parity): `actor.wearing[18880]` style uses legacy 5-digit vnums; switch
-- to `actor:has_equipped((188 * 100 + 80))`-style or composite-key lookups
-- once the runtime API for "is wearing object id X" is finalized.

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: tag
if not (cmd == "tag") then
    return true  -- Not our command
end
-- *** Set entity IDs ****
-- Mobiles
local referee = 18880
-- Objects
local team_a_id = 18880
local team_b_id = 18881
local flag_a = 82
local flag_b = 83
-- Rooms
local zone_a_start = 3500
local zone_a_end = 3599
local jail_a = 80
local home_a = 3500
local flag_room_a = 3500
local zone_b_start = 8000
local zone_b_end = 8199
local jail_b = 81
local home_b = 8025
local flag_room_b = 8050
-- Player has been forced to deactivate their armband
if arg == "DeactivateArmband" then
    globals.inactive = "yes"
    return true
    -- Player has been forced to reactivate their armband
elseif arg == "ReactivateArmband" then
    globals.inactive = "no"
    return true
    -- Player is wearing an inactive armband
elseif globals.inactive == "yes" then
    actor:send("Sorry, you can't tag anyone right now!")
    -- Player tries to tag self
elseif (arg == "self") or (actor.name == arg.name) then
    actor:send("There's really no point to that, now is there?")
    -- Player tries to tag someone who isn't in room doesn't exist
elseif arg.room ~= actor.room then
    actor:send("Tag whom?  They're not here!")
    -- Player tries to tag immortal
elseif arg.level > 99 then
    actor:send("It's not very nice to tag immortals.")
    -- Player is holding the flag
elseif (actor.wearing[flag_a]) or (actor.wearing[flag_b]) then
    actor:send("You cannot tag someone while holding the flag!")
    -- Player tries to tag player or referee mob
elseif (arg.is_player) or (arg.id == "referee") then
    local arg_team
    -- Player tries to tag someone on team A
    if arg.wearing[team_a_id] then
        arg_team = team_a_id
        -- Player tries to tag someone on team B
    elseif arg.wearing[team_b_id] then
        arg_team = team_b_id
        -- Player tries to tag someone who isn't playing
    else
        actor:send(tostring(arg.name) .. " doesn't seem to be playing.")
    end
    -- Player tries to tag someone who is playing
    if arg_team then
        local actor_home, actor_jail, actor_flag_room, actor_flag
        local at_home, in_jail
        -- Player is on team A
        if self.id == "team_a_id" then
            actor_home = home_a
            actor_jail = jail_a
            actor_flag_room = flag_room_a
            actor_flag = flag_a
            -- Player is in home zone
            if (actor.room >= zone_a_start) and (actor.room <= zone_a_end) then
                at_home = "yes"
            end
            -- Player is on team B
        elseif self.id == "team_b_id" then
            actor_home = home_b
            actor_jail = jail_b
            actor_flag_room = flag_room_b
            actor_flag = flag_b
            -- Player is in home zone
            if (actor.room >= zone_b_start) and (actor.room <= zone_b_end) then
                at_home = "yes"
            end
        end
        -- Player tries to tag someone in jail
        if (actor.room == "jail_a") or (actor.room == "jail_b") then
            in_jail = "yes"
        end
        -- Player tries to tag someone on the same team
        if arg_team == self.id then
            -- Player tags teammate in jail (Return both to team home room)
            if in_jail == "yes" then
                arg:teleport(get_room(math.floor(actor_home / 100), actor_home % 100))
                arg:send(tostring(actor.name) .. " tags you, rescuing you from jail!")
                self.room:send_except(arg, tostring(actor.name) .. " appears in a bright flash of light!")
                self.room:send_except(arg, tostring(arg.name) .. " appears in a bright flash of light!")
                self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. ", rescuing " .. tostring(arg.object) .. " from jail!")
                actor:send("You tag " .. tostring(arg.name) .. ", rescuing " .. tostring(arg.object) .. " from jail!")
                actor:teleport(get_room(math.floor(actor_home / 100), actor_home % 100))
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
                    arg:teleport(get_room(188, actor_jail))
                    arg:send(tostring(actor.name) .. " tags you, banishing you for jail-guarding!")
                    self.room:send_except(arg, tostring(arg.name) .. " appears in a bright flash of light!")
                    self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. ", banishing " .. tostring(arg.object) .. " for jail-guarding!")
                    actor:send("You tag " .. tostring(arg.name) .. ", banishing " .. tostring(arg.object) .. " for jail-guarding!")
                    actor:teleport(get_room(math.floor(actor_home / 100), actor_home % 100))
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
                arg:teleport(get_room(188, actor_jail))
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
                local actor_room = actor.room
                arg:command("remove ctf-flag")
                actor:teleport(get_room(math.floor(actor_flag_room / 100), actor_flag_room % 100))
                self.room:spawn_object(188, actor_flag)
                -- TODO(parity): teleporting back via numeric vnum math (`actor_room / 100`)
                -- assumes actor.room is numeric. If the runtime gives a Room object,
                -- store and re-teleport to the object directly.
                actor:teleport(get_room(math.floor(actor_room / 100), actor_room % 100))
            end
        end
    end
    -- Player tries to tag other mob
else
    actor:send("You can only tag players!")
end