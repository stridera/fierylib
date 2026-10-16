-- Trigger: fierytag_bat_capturetheflag
-- Zone: 188, ID: 97
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18897

-- Rewritten from DG Script #18897: fierytag_bat_capturetheflag
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
return false
