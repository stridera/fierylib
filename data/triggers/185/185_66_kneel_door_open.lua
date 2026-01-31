-- Trigger: kneel_door_open
-- Zone: 185, ID: 66
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18566

-- Converted from DG Script #18566: kneel_door_open
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: kneel
if not (cmd == "kneel") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
-- switch on cmd
if cmd == "k" then
    return _return_value
end
if actor.alignment > -349 then
    actor.name:send("A bright white beam of light descends upon you.")
    self.room:send_except(actor.name, "A bright beam of white light descends upon " .. tostring(actor.name) .. ".")
    get_room(185, 66):exit("west"):set_state({has_door = true})
    get_room(185, 66):exit("west"):set_state({hidden = false})
    get_room(185, 66):exit("west"):set_state({name = "large wooden door"})
    -- REMOVED: doors.set_key (not supported): -- REMOVED: doors.set_key (not supported): doors.set_key(get_room(185, 66), "west", -1)
    get_room(185, 66):exit("west"):set_state({description = "A large wooden door bars your way."})
    wait(3)
    actor.name:send("A door in the cross to the west opens silently.")
    self.room:send_except(actor.name, "A door in the cross to the west opens silently.")
else
    actor.name:send("A bright white beam of light descends upon you.")
    self.room:send_except(actor.name, "A bright white beam of light descends upon " .. tostring(actor.name) .. ".")
    wait(2)
    actor.name:send("The light becomes increasingly bright, and turns painful!")
    actor.name:damage(179)  -- type: physical
    self.room:send_except(actor.name, "The light brightens significantly, burning " .. tostring(actor.name) .. "'s skin.")
end
return _return_value