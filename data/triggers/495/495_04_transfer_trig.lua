-- Trigger: Transfer trig
-- Zone: 495, ID: 4
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #49504
-- Banishes good-aligned holy classes (Priest, Cleric, Paladin, Ranger,
-- Monk, Druid) eastward, sending them to a peaceful sanctuary instead.

-- Command filter: east / e
if not (cmd == "east" or cmd == "e") then
    return true  -- Not our command
end

if not actor.is_player then
    return true
end

local class = actor.class or ""
local is_holy_class = string.find(class, "Priest")
    or string.find(class, "Cleric")
    or string.find(class, "Paladin")
    or string.find(class, "Ranger")
    or string.find(class, "Monk")
    or string.find(class, "Druid")

if not is_holy_class then
    return true
end

if actor.alignment < 350 then
    actor:send("You have no business here in the realm of shadow and death.")
    actor:send("You find yourself in a lighter place at peace.")
    actor:teleport(get_room(30, 2))
end
