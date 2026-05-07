-- Trigger: kneel_door_open
-- Zone: 185, ID: 66
-- Type: WORLD, Flags: COMMAND
--
-- Player kneeling in this room: good-aligned (alignment > -349) opens
-- the wooden door to the west; otherwise they take radiant damage.
--
-- TODO(parity): the legacy implementation set the door's lock key as
-- well, but doors.set_key isn't exposed in the rs runtime yet.

if not (cmd == "kneel") then
    return true
end

if actor.alignment > -349 then
    actor:send("A bright white beam of light descends upon you.")
    self.room:send_except(actor, "A bright beam of white light descends upon " .. tostring(actor.name) .. ".")
    local west = get_room(185, 66):exit("west")
    west:set_state({has_door = true})
    west:set_state({hidden = false})
    west:set_state({name = "large wooden door"})
    west:set_state({description = "A large wooden door bars your way."})
    wait(3)
    actor:send("A door in the cross to the west opens silently.")
    self.room:send_except(actor, "A door in the cross to the west opens silently.")
else
    actor:send("A bright white beam of light descends upon you.")
    self.room:send_except(actor, "A bright beam of white light descends upon " .. tostring(actor.name) .. ".")
    wait(2)
    actor:send("The light becomes increasingly bright, and turns painful!")
    actor:damage(179)
    self.room:send_except(actor, "The light brightens significantly, burning " .. tostring(actor.name) .. "'s skin.")
end
return true
