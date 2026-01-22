-- Trigger: Frakati guard blocker
-- Zone: 83, ID: 4
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN (reviewed)
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
if world.count_mobiles(tostring(guardvnum)) > 0 and actor.room == entryroom and actor.id == -1 then
    local blocked = false
    local guard = nil
    local person = self.people
    while person do
        if person.vnum == guardvnum then
            guard = person
            if person:is_standing() or person:is_fighting() or person:is_flying() then
                blocked = true
            end
        end
        person = person.next_in_room
    end
    if blocked and guard then
        if actor.level < 100 then
            local entrydir = get_opposite_dir(direction)
            actor.room:send_except(actor, tostring(guard.name) .. " blocks " .. tostring(actor.name) .. " as " .. tostring(actor.heshe) .. " tries to go " .. tostring(entrydir) .. ".")
            actor:send(tostring(guard.name) .. " steps purposefully into your way.")
            _return_value = false
        else
            actor.room:send_except(actor, tostring(guard.name) .. " makes no move as " .. tostring(actor.name) .. " passes.")
            _return_value = true
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value
