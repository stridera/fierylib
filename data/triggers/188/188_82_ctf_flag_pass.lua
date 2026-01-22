-- Trigger: ctf_flag_pass
-- Zone: 188, ID: 82
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #18882

-- Converted from DG Script #18882: ctf_flag_pass
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: pass
if not (cmd == "pass") then
    return true  -- Not our command
end
-- *** Set vnum variables ****
-- Mobiles
local referee = 18880
-- Objects
local vnum_a = 18880
local vnum_b = 18881
-- Rooms
local flag_room_a = 3520
local flag_room_b = 8600
-- Player tries to pass to self
if (arg == "self") or (actor == "arg") then
    actor:send("There's really no point to that, now is there?")
    -- Player tries to pass to someone who isn't in room or doesn't exist
elseif arg.room ~= actor.room then
    actor:send("Pass the flag to whom?  They're not here!")
    -- Player tries to pass to an immortal
elseif arg.level > 99 then
    actor:send("You can't pass to an immortal!")
    -- Player tries to pass to a player or the referee mob
elseif (arg.id == -1) or (arg.id == "referee") then
    -- Player tries to pass to someone on team A
    if arg.wearing[vnum_a] then
        local arg_team = team_a
        -- Player tries to pass to someone on team B
    elseif arg.wearing[vnum_b] then
        local arg_team = team_b
        -- Player tries to pass to someone who isn't playing
    else
        actor:send(tostring(arg.name) .. " doesn't seem to be playing.")
    end
    -- Player passes to someone who is playing
    if arg_team then
        -- Player is on team A
        if self.id == "vnum_a" then
            local actor_flag_room = flag_room_a
            -- Player is on team B
        elseif self.id == "vnum_b" then
            local actor_flag_room = flag_room_b
        end
        -- Player passes to someone on the same team
        if arg_team == self.id then
            arg:send(tostring(actor.name) .. " quickly passes " .. tostring(self.shortdesc) .. " to you.")
            arg:teleport(get_room(1000, 0))
            actor:send("You slyly hand off " .. tostring(self.shortdesc) .. " to " .. tostring(arg.name) .. ".")
            self.room:send_except(actor, tostring(actor.name) .. " quietly passes a flag to " .. tostring(arg.name) .. ".")
            arg:teleport(get_room(vnum_to_zone(actor.room), vnum_to_local(actor.room)))
            self.room:spawn_object(vnum_to_zone(self.id), vnum_to_local(self.id))
            arg:command("get ctf-flag")
            world.destroy(self)
            -- Player passes to someone on an enemy team (Reset flag)
        else
            actor:send("You accidentally pass the flag to " .. tostring(arg.name) .. ", resetting it.")
            actor:teleport(get_room(vnum_to_zone(actor_flag_room), vnum_to_local(actor_flag_room)))
            self.room:spawn_object(vnum_to_zone(self.id), vnum_to_local(self.id))
            actor:teleport(get_room(vnum_to_zone(arg.room), vnum_to_local(arg.room)))
            world.destroy(self)
        end
    end
    -- Player tries to pass to other mob
else
    actor:send("You can only pass the flag to players!")
end