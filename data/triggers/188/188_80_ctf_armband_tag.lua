-- Trigger: ctf_armband_tag
-- Zone: 188, ID: 80
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18880

-- Rewritten from DG Script #18880: ctf_armband_tag
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%
--
-- Capture the flag. The team A / team B armbands (objects 188:80 and
-- 188:81) let a player tag a player (or the referee) in the room: tag an
-- enemy in your own zone to send them to your jail, tag a teammate in
-- jail to free them. "tag DeactivateArmband" / "tag ReactivateArmband"
-- (forced on the tagged player) switch the armband off and on.

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2
-- (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: tag
if not (cmd == "tag") then
    return true  -- Not our command
end

local dg = require("dg")

-- *** Set entity IDs ****
-- Mobiles and objects are ids in zone 188
local referee = 80
local team_a_id = 80
local team_b_id = 81
local flag_a = 82
local flag_b = 83
-- Rooms are legacy numbers (zone * 100 + id), see dg.room
local zone_a_start = 3500
local zone_a_end = 3599
local jail_a = 18880
local home_a = 3500
local flag_room_a = 3500
local zone_b_start = 8000
local zone_b_end = 8199
local jail_b = 18881
local home_b = 8025
local flag_room_b = 8050

-- The legacy number of a room handle.
local function vnum_of(room)
    return dg.to_vnum(room.zone_id, room.local_id)
end

-- Put `who` in the room with that legacy number (DG oteleport).
local function send_to(who, vnum)
    local room = get_room(dg.room(vnum))
    if room then
        who:teleport(room)
    end
end

-- DG oechoaround: everyone in `who`'s room now, except `who`.
local function around(who, msg)
    who.room:send_except(who, msg)
end

local word = string.lower(string.match(arg or "", "^%s*(.-)%s*$"))

-- Player has been forced to deactivate their armband
if word == "deactivatearmband" then
    globals.inactive = "yes"
    return false
end
-- Player has been forced to reactivate their armband
if word == "reactivatearmband" then
    globals.inactive = "no"
    return false
end
-- Player is wearing an inactive armband
if globals.inactive == "yes" then
    actor:send("Sorry, you can't tag anyone right now!")
    return false
end

-- Who is being tagged: someone in this room
local tagged
if word ~= "" and word ~= "self" then
    tagged = actor.room:find_actor(word)
end

if word == "self" or (tagged and tagged.name == actor.name) then
    -- Player tries to tag self
    actor:send("There's really no point to that, now is there?")
    return false
end
if not tagged then
    -- Player tries to tag someone who isn't in room or doesn't exist
    actor:send("Tag whom?  They're not here!")
    return false
end
if tagged.level > 99 then
    -- Player tries to tag immortal
    actor:send("It's not very nice to tag immortals.")
    return false
end
if actor:has_equipped(188, flag_a) or actor:has_equipped(188, flag_b) then
    -- Player is holding the flag
    actor:send("You cannot tag someone while holding the flag!")
    return false
end

-- Player tries to tag player or referee mob
local is_referee = tagged.is_npc and tagged.zone_id == 188
    and tagged.id == referee
if not (tagged.is_player or is_referee) then
    -- Player tries to tag other mob
    actor:send("You can only tag players!")
    return false
end

local arg_team
if tagged:has_equipped(188, team_a_id) then
    -- Player tries to tag someone on team A
    arg_team = team_a_id
elseif tagged:has_equipped(188, team_b_id) then
    -- Player tries to tag someone on team B
    arg_team = team_b_id
else
    -- Player tries to tag someone who isn't playing
    actor:send(tostring(tagged.name) .. " doesn't seem to be playing.")
    return false
end

local here = vnum_of(actor.room)
local actor_home, actor_jail, actor_flag_room, actor_flag
local at_home, in_jail
if self.zone_id == 188 and self.id == team_a_id then
    -- Player is on team A
    actor_home = home_a
    actor_jail = jail_a
    actor_flag_room = flag_room_a
    actor_flag = flag_a
    -- Player is in home zone
    if here >= zone_a_start and here <= zone_a_end then
        at_home = "yes"
    end
elseif self.zone_id == 188 and self.id == team_b_id then
    -- Player is on team B
    actor_home = home_b
    actor_jail = jail_b
    actor_flag_room = flag_room_b
    actor_flag = flag_b
    -- Player is in home zone
    if here >= zone_b_start and here <= zone_b_end then
        at_home = "yes"
    end
end
-- Player tries to tag someone in jail
if here == jail_a or here == jail_b then
    in_jail = "yes"
end

local tname = tostring(tagged.name)
local aname = tostring(actor.name)

if arg_team == self.id then
    -- Player tries to tag someone on the same team
    if in_jail == "yes" then
        -- Player tags teammate in jail (Return both to team home room)
        send_to(tagged, actor_home)
        tagged:send(aname .. " tags you, rescuing you from jail!")
        around(tagged, aname .. " appears in a bright flash of light!")
        around(tagged, tname .. " appears in a bright flash of light!")
        around(actor, aname .. " tags " .. tname .. ", rescuing "
            .. tostring(tagged.objective) .. " from jail!")
        actor:send("You tag " .. tname .. ", rescuing "
            .. tostring(tagged.objective) .. " from jail!")
        send_to(actor, actor_home)
        tagged:command("tag ReactivateArmband")
        actor:command("look")
        tagged:command("look")
    elseif at_home == "yes" then
        -- Player tries to tag teammate in home zone
        actor:send(tname .. " doesn't need saving in your own zone!")
    else
        -- Player tries to tag teammate not in home zone, but not in jail
        actor:send(tname .. " doesn't need saving right now!")
    end
    return false
end

-- Player tries to tag someone on an enemy team
if in_jail == "yes" then
    -- Player tries to tag enemy in jail
    if here == actor_jail then
        -- Player tries to tag enemy in player's jail
        actor:send(tname .. " is already in your jail!")
    else
        -- Player tags enemy in enemy's jail (Send enemy to jail and
        -- player to home)
        send_to(tagged, actor_jail)
        tagged:send(aname .. " tags you, banishing you for jail-guarding!")
        around(tagged, tname .. " appears in a bright flash of light!")
        around(actor, aname .. " tags " .. tname .. ", banishing "
            .. tostring(tagged.objective) .. " for jail-guarding!")
        actor:send("You tag " .. tname .. ", banishing "
            .. tostring(tagged.objective) .. " for jail-guarding!")
        send_to(actor, actor_home)
        around(actor, aname .. " appears in a bright flash of light!")
        tagged:command("tag DeactivateArmband")
        actor:command("look")
        tagged:command("look")
    end
elseif here == actor_flag_room then
    -- Player tries to tag enemy in player's flag room
    actor:send("You can't tag " .. tname .. " in your flag room!")
elseif at_home == "yes" then
    -- Player tags enemy in player's zone (Send enemy to player's jail)
    tagged:send(aname .. " tags you, sending you to "
        .. tostring(actor.possessive) .. " jail!")
    send_to(tagged, actor_jail)
    around(tagged, tname .. " appears in a bright flash of light!")
    around(actor, aname .. " tags " .. tname .. ", sending "
        .. tostring(tagged.objective) .. " to jail!")
    actor:send("You tag " .. tname .. ", sending "
        .. tostring(tagged.objective) .. " to your jail!")
    tagged:command("tag DeactivateArmband")
    tagged:command("look")
else
    -- Player tries to tag enemy outside of player's zone
    actor:send("Tagging " .. tname .. " has no effect outside your zone!")
end

-- Player tags enemy holding flag: the flag goes back to the tagger's flag
-- room and the tagger returns
if actor_flag and (tagged:has_equipped(188, flag_a)
        or tagged:has_equipped(188, flag_b)) then
    local actor_room = actor.room
    tagged:command("remove ctf-flag")
    send_to(actor, actor_flag_room)
    actor.room:spawn_object(188, actor_flag)
    actor:teleport(actor_room)
end
return false
