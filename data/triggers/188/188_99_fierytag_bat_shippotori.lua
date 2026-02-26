-- Trigger: fierytag_bat_shippotori
-- Zone: 188, ID: 99
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18899

-- Converted from DG Script #18899: fierytag_bat_shippotori
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
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
if (arg == "self") or (actor.name == arg.name) then
    actor:send("Now that seems a little pointless, doesn't it?")
elseif actor.room ~= arg.room then
    actor:send("Tag who? They don't seem to be here!")
elseif arg.id ~= -1 then
    actor:send("You can only tag players!")
elseif arg.level > 99 then
    actor:send("You cannot tag immortals!")
elseif arg:has_equipped("18899") then
    arg:teleport(get_room(1000, 0))
    self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. " with a FieryTag bat!")
    arg:teleport(get_room(vnum_to_zone(actor.room), vnum_to_local(actor.room)))
    actor:send("You tag " .. tostring(arg.name) .. " with a whack of your FieryTag bat!")
    arg:send("Tag! " .. tostring(actor.name) .. " tags you with a whack of " .. tostring(actor.possessive) .. " FieryTag bat!")
    self.room:spawn_mobile(188, 96)
    self.room:find_actor("fiery-tagger-announcer"):command("gossip %actor.name% has tagged %arg.name%!  %arg.name% is out!")
    world.destroy(self.room:find_object("fiery-tagger-announcer"))
    arg:command("rem bat")
else
    actor:send(tostring(arg.name) .. " isn't in the game!")
end
return _return_value