-- Trigger: Frakati guard blocker
-- Zone: 83, ID: 4
-- Type: WORLD, Flags: PREENTRY
-- Status: NEEDS_REVIEW
--
-- Generic guard-blocker template (per the original DG comment header):
-- copy this trigger, change entry_room/guard proto, and attach it to the room
-- beyond the guard so the guard can deny passage.
--
-- Behaviour: when a player attempts to enter from entry_room and a standing
-- guard mob is present in the trigger's room, block movement (return false)
-- for sub-level-100 actors and emit a "blocks you" message; level >=100
-- actors pass freely with a "makes no move" echo.
--
-- TODO(triggers/083_04): The original DG script is a generic template that is
-- never demonstrably attached to any zone-83 room (the wld trigger refs we
-- found point to other scripts). The room->guard relationship and `self.people`
-- semantics need verification against an actual deployment before this can be
-- considered production-correct. Returning true (allow) by default keeps it
-- a no-op until reviewed.
--
-- Original DG Script: #8304

-- Configuration: copy this trigger and update these for the room being guarded.
local entry_zone, entry_id = 83, 52       -- room with the guard (legacy 8352)
local guard_zone, guard_local = 83, 32    -- guard mob prototype (legacy 8332)

-- Default: allow the action.
if not actor.is_player then
    return true
end

local entry_room = get_room(entry_zone, entry_id)
local source = actor.room
if not source or source.zone_id ~= entry_zone or source.local_id ~= entry_id then
    return true
end

-- Look for a standing guard in the trigger's room (self).
local guard
for _, person in ipairs(self.actors) do
    if person.zone_id == guard_zone and person.local_id == guard_local then
        local pos = person.position_name
        if pos == "Standing" or pos == "Fighting" or pos == "Flying" then
            guard = person
            break
        end
    end
end

if not guard then
    return true
end

if actor.level < 100 then
    self:send_except(actor, tostring(guard.name) .. " blocks " .. tostring(actor.name) ..
        " as " .. tostring(actor.subject) .. " tries to pass.")
    actor:send(tostring(guard.name) .. " steps purposefully into your way.")
    return false
else
    self:send_except(actor, tostring(guard.name) .. " makes no move as " ..
        tostring(actor.name) .. " passes.")
    return true
end
