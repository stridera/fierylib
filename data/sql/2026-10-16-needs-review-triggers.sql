-- Rewrite NEEDS_REVIEW triggers 53:42, 188:80, 188:97 (room handles compared by zone/id)
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- file (md5 of the body or of the whole file, with or without the final
-- newline), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/053/053_42_monk_vision_command_read.lua
  (53, 42, $trig$-- Rewritten from DG Script #5342: Monk Vision command read
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%
--
-- Each of the nine Sight items is bound to one place (a room), a quest
-- stage, a gem the monk must carry and the previous Sight, which must be
-- worn. Reading the item in its place, at its stage, takes four rounds of
-- reading; leaving or fighting breaks the focus.

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2
-- (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: read
if not (cmd == "read") then
    return true  -- Not our command
end

local dg = require("dg")

-- This item (zone, id) -> place (legacy room number), quest stage, the
-- gem (zone, id) carried, the previous Sight (zone, id) worn.
local VISIONS = {
    ["590:6"]   = { 4328,  1, 555, 82, 2, 190 },
    ["185:5"]   = { 58707, 2, 555, 91, 2, 191 },
    ["85:1"]    = { 18597, 3, 556, 23, 2, 192 },
    ["125:32"]  = { 58102, 4, 556, 55, 2, 193 },
    ["162:9"]   = { 16057, 5, 556, 65, 2, 194 },
    ["430:13"]  = { 59054, 6, 556, 78, 2, 195 },
    ["530:9"]   = { 49079, 7, 557, 10, 2, 196 },
    ["584:15"]  = { 11820, 8, 557, 22, 2, 197 },
    ["584:12"]  = { 52075, 9, 557, 41, 2, 198 },
}

local vision = VISIONS[self.zone_id .. ":" .. self.id]
if not vision then
    return true  -- Not one of the Sight items
end
local place_zone, place_id = dg.room(vision[1])
local stage = vision[2]
local hasgem = actor:has_item(vision[3], vision[4])
local hasvision = actor:has_equipped(vision[5], vision[6])

-- True while the reader stands in this Sight's place.
local function in_place()
    local room = actor.room
    return room.zone_id == place_zone and room.local_id == place_id
end

-- Everything the monk reads here is magenta.
local function tell(msg)
    actor:send("<magenta>" .. msg .. "</>")
end

local visionstage = actor:get_quest_stage("monk_vision")
if not (in_place() and visionstage == stage and hasvision and hasgem) then
    return true  -- Not ready: the command carries on to the normal handler
end

if dg.flag(actor:get_quest_var("monk_vision:visiontask4")) then
    tell("You have already expanded your mind to its "
         .. "current limits.")
    return false
end

if actor.is_fighting then
    tell("You cannot properly focus while fighting!")
    return false
end

tell("You begin to read " .. tostring(self.shortdesc) .. "...")
wait(4)
if actor.is_fighting then
    tell("You cannot properly focus while fighting!")
    return false
end
if not in_place() then
    tell("You must be in the proper place to keep reading!")
    return false
end

for _ = 1, 3 do
    tell("You continue to read...")
    wait(4)
    if actor.is_fighting then
        tell("You cannot properly focus while fighting!")
        return false
    end
    if not in_place() then
        tell("You must be in the proper place to keep reading!")
        return false
    end
end

actor:send("<b:magenta>You feel your awareness broadening!</>")
actor:set_quest_var("monk_vision", "visiontask4", 1)
return false$trig$, ARRAY['7b9f1ba1b7df94e524687c73c3cdd72c', '6c46a60f975d49d5818a2c2c84fa90c6', '90d1bef6ea11c2d1f7bda3365eb9c7e6']),
  -- data/triggers/188/188_80_ctf_armband_tag.lua
  (188, 80, $trig$-- Rewritten from DG Script #18880: ctf_armband_tag
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
return false$trig$, ARRAY['f62f6226960ef7ae6f61b73d30a4e56b', '2dbb9501fcced7f9703f4d13a9e8d554', 'b147348a4bc33fc7a507b97681b1b215']),
  -- data/triggers/188/188_97_fierytag_bat_capturetheflag.lua
  (188, 97, $trig$-- Rewritten from DG Script #18897: fierytag_bat_capturetheflag
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%
--
-- FieryTag, capture-the-flag version. The teams are the sexes: males
-- (zone 30), females (zone 80) and neutral (zone 35) each have a home
-- zone and a jail. Tag an opponent in your own zone to send them to your
-- jail; tag a teammate in an opponent's jail to bring both of you home.

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2
-- (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: tag
if not (cmd == "tag") then
    return true  -- Not our command
end

local dg = require("dg")

-- Rooms are legacy numbers (zone * 100 + id), see dg.room
local zone_a_start = 3000
local zone_a_end = 3199
local zone_a_jail = 3009
local zone_a_home = 3054
local zone_b_start = 8000
local zone_b_end = 8199
local zone_b_jail = 8133
local zone_b_home = 8049
local zone_c_start = 3500
local zone_c_end = 3699
local zone_c_jail = 3514
local zone_c_home = 3500

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

-- Who is being tagged: someone in this room
local tagged
if word ~= "" and word ~= "self" then
    tagged = actor.room:find_actor(word)
end

if word == "self" or (tagged and tagged.name == actor.name) then
    actor:send("Now that seems a little pointless, doesn't it?")
    return false
end
if not tagged then
    actor:send("Tag who? They don't seem to be here!")
    return false
end
if tagged.is_npc then
    actor:send("You can only tag players!")
    return false
end
if tagged.level > 99 then
    actor:send("You cannot tag immortals!")
    return false
end

local here = vnum_of(actor.room)
local actor_home, actor_jail, actor_at_home
local arg_same_team, arg_in_jail
if actor.gender == "male" then
    actor_home = zone_a_home
    actor_jail = zone_a_jail
    if here >= zone_a_start and here <= zone_a_end then
        actor_at_home = "yes"
    end
elseif actor.gender == "female" then
    actor_home = zone_b_home
    actor_jail = zone_b_jail
    if here >= zone_b_start and here <= zone_b_end then
        actor_at_home = "yes"
    end
elseif actor.gender == "neutral" then
    actor_home = zone_c_home
    actor_jail = zone_c_jail
    if here >= zone_c_start and here <= zone_c_end then
        actor_at_home = "yes"
    end
end
if tagged.gender == actor.gender then
    arg_same_team = "yes"
end
local there = vnum_of(tagged.room)
if there == zone_a_jail or there == zone_b_jail or there == zone_c_jail then
    arg_in_jail = "yes"
end

local tname = tostring(tagged.name)
local aname = tostring(actor.name)

if here == actor_jail then
    if arg_same_team == "yes" then
        -- Tagging teammate in opponent jail, rescue them
        send_to(tagged, actor_home)
        tagged:send(aname .. " tags you, returning you to home!")
        around(actor, aname .. " tags " .. tname .. ", returning "
            .. tostring(tagged.objective) .. " to home!")
        actor:send("You tag " .. tname .. ", returning "
            .. tostring(tagged.objective) .. " to home!")
        send_to(actor, actor_home)
        tagged:command("look")
        actor:command("look")
    else
        actor:send("That's no good.  " .. tname
            .. " is already in your jail.")
    end
elseif actor_at_home == "yes" then
    if arg_same_team == "yes" then
        -- Tagging teammate in home zone, do nothing
        actor:send("But you're in your own zone!  " .. tname
            .. " is on your team!")
    else
        -- Tagging opponent in home zone, teleport opponent to jail
        tagged:command("remove fiery-tag-bat")
        tagged:command("junk fiery-tag-bat")
        send_to(tagged, actor_jail)
        around(actor, aname .. " tags " .. tname .. "!  To jail " .. tname
            .. " goes!")
        actor:send("You tag " .. tname .. ", sending "
            .. tostring(tagged.objective) .. " to jail!")
        tagged:send(aname .. " tags you, sending you to jail!")
        tagged:command("look")
    end
elseif arg_same_team == "yes" then
    if arg_in_jail == "yes" then
        -- Tagging teammate in opponent jail, rescue them
        actor.room:spawn_object(188, 97)
        tagged:heal(10)
        tagged:command("wake")
        tagged:command("get fiery-tag-bat")
        send_to(tagged, actor_home)
        tagged:send(aname .. " tags you, rescuing you from your "
            .. "imprisonment!")
        around(actor, aname .. " tags " .. tname
            .. ", returning both of them to their zone!")
        actor:send("You tag " .. tname .. ", rescuing "
            .. tostring(tagged.objective) .. " from "
            .. tostring(tagged.possessive) .. " imprisonment!")
        send_to(actor, actor_home)
        tagged:command("look")
        actor:command("look")
    else
        -- Tagging teammate in opponent zone, but not jail, do nothing
        actor:send(tname .. " doesn't need rescuing right now.")
    end
else
    -- Tagging opponent in opponent zone, do nothing
    actor:send("No point in tagging " .. tostring(tagged.objective)
        .. " if you're not in your zone.")
end
return false$trig$, ARRAY['ef39a5e7c79be507a37fd64026209fea', '53c2e9d9f6cf4b3ff578e9c286dec0aa', '6e03f2713247801695d0d406ac17848f'])
) AS v(zone_id, id, commands, old_md5s)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = ANY (v.old_md5s)
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
