-- Trigger: Frakati guard blocker
-- Zone: 83, ID: 4
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #8304

-- Converted from DG Script #8304: Frakati guard blocker
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
-- This is a general trigger for mobiles guarding certain exits.
-- To use it, make a copy of the trigger, and modify these two variables.
-- Then apply the trigger to the room beyond the guard.
local entryroom = 8352
local guardvnum = 8332
if get.mob_count[guardvnum] and actor.room == "entryroom" and actor.id == -1 then
    local blocked = 0
    local person = self.people
    while person do
        if person.id == "guardvnum" then
            local guard = person
            if string.find(guard.position, "Standing") or string.find(guard.position, "Fighting") or string.find(guard.position, "Flying") then
                local blocked = 1
            end
        end
        local person = person.next_in_room
    end
    if blocked then
        if actor.level < 100 then
            local entrydir = get.opposite_dir[direction]
            get_room(vnum_to_zone(actor.room), vnum_to_local(actor.room)):at(function()
                self.room:send_except(actor, tostring(guard.name) .. " blocks " .. tostring(actor.name) .. " as " .. tostring(actor.heshe) .. " tries to go " .. tostring(entrydir) .. ".")
            end)
            get_room(vnum_to_zone(actor.room), vnum_to_local(actor.room)):at(function()
                actor:send(tostring(guard.name) .. " steps purposefully into your way.")
            end)
            _return_value = false
        else
            get_room(vnum_to_zone(actor.room), vnum_to_local(actor.room)):at(function()
                self.room:send_except(actor, tostring(guard.name) .. " makes no move as " .. tostring(actor.name) .. " passes.")
            end)
            _return_value = true
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value