-- Trigger: Auto door opener
-- Zone: 495, ID: 3
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49503
-- A Necromancer who utters "I am child of Borgan!" reveals a hidden
-- stairway leading up from room 495/13 for 20 ticks before it seals shut.

-- Speech keyword filter: literal phrase (case-insensitive)
if not string.find(string.lower(speech), "i am child of borgan") then
    return true
end

if not actor.is_player then
    return true
end

if not string.find(actor.class or "", "Necromancer") then
    return true
end

local stair_room = get_room(495, 13)
stair_room:exit("up"):set_state({hidden = false})
self:send("With a terrifying crash the ceiling above falls downward, ceasing. A stairway leads upwards.")
wait(20)
stair_room:exit("up"):set_state({hidden = true})
