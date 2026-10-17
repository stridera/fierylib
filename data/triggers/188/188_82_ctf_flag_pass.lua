-- Trigger: ctf_flag_pass
-- Zone: 188, ID: 82
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18882

-- Rewritten from DG Script #18882: ctf_flag_pass
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%
--
-- Capture the flag. The flags (188:82 team A's, 188:83 team B's) carry this
-- trigger. A player holding a flag types "pass flag <player>": the target is
-- looked up in the room (arg is only the typed word). Passing to a teammate
-- hands the flag over; passing to the other team resets the flag at its home
-- room. Teams are told apart by the armband worn (188:80 team A, 188:81
-- team B), as in the armband trigger 188:80.

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2
-- (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pass
if not (cmd == "pass") then
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
-- Rooms are legacy numbers (zone * 100 + id), see dg.room: where each
-- team's flag lives (the same rooms as the armband trigger 188:80)
local flag_room_a = 3500
local flag_room_b = 8050

-- "pass flag <who>": the last word is the target
local words = {}
for w in string.gmatch(string.lower(arg or ""), "%S+") do
    words[#words + 1] = w
end
local word = words[#words] or ""
if word == "flag" or word == "" then
    actor:send("Pass the flag to whom?")
    return false
end

-- Who is being passed to: someone in this room
local target
if word ~= "self" then
    target = actor.room:find_actor(word)
end

if word == "self" or (target and target.name == actor.name) then
    -- Player tries to pass to self
    actor:send("There's really no point to that, now is there?")
    return false
end
if not target then
    -- Player tries to pass to someone who isn't in room or doesn't exist
    actor:send("Pass the flag to whom?  They're not here!")
    return false
end
if target.level > 99 then
    -- Player tries to pass to an immortal
    actor:send("You can't pass to an immortal!")
    return false
end

-- Player tries to pass to a player or the referee mob
local is_referee = target.is_npc and target.zone_id == 188
    and target.id == referee
if not (target.is_player or is_referee) then
    -- Player tries to pass to other mob
    actor:send("You can only pass the flag to players!")
    return false
end

local function team_of(who)
    if who:has_equipped(188, team_a_id) then
        return team_a_id
    elseif who:has_equipped(188, team_b_id) then
        return team_b_id
    end
    return nil
end

local tname = tostring(target.name)
local aname = tostring(actor.name)
local target_team = team_of(target)
if not target_team then
    -- Player tries to pass to someone who isn't playing
    actor:send(tname .. " doesn't seem to be playing.")
    return false
end

-- This flag's team and home room
local flag_room
if self.zone_id == 188 and self.id == flag_a then
    flag_room = flag_room_a
elseif self.zone_id == 188 and self.id == flag_b then
    flag_room = flag_room_b
end

local shortdesc = tostring(self.shortdesc)
local here = actor.room
if target_team == team_of(actor) then
    -- Player passes to someone on the same team
    target:send(aname .. " quickly passes " .. shortdesc .. " to you.")
    actor:send("You slyly hand off " .. shortdesc .. " to " .. tname .. ".")
    here:send_except(actor, aname .. " quietly passes a flag to " .. tname .. ".")
    here:spawn_object(self.zone_id, self.id)
    target:command("get ctf-flag")
    world.destroy(self)
else
    -- Player passes to someone on an enemy team (Reset flag)
    actor:send("You accidentally pass the flag to " .. tname .. ", resetting it.")
    local home = flag_room and get_room(dg.room(flag_room))
    if home then
        home:spawn_object(self.zone_id, self.id)
    end
    world.destroy(self)
end
return false
