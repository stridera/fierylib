-- Trigger: submit_command_trigger
-- Zone: 18, ID: 11
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1811

-- Converted from DG Script #1811: submit_command_trigger
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: submit
if not (cmd == "submit") then
    return true  -- Not our command
end
self:command("blink")
actor.name:command("forget all")
actor.name:send("You feel drained.")
local rm = random(1, 10)
-- switch on rm
if rm == 1 then
    actor.name:teleport(get_room(520, 70))
elseif rm == 2 then
    actor.name:teleport(get_room(480, 80))
elseif rm == 3 then
    actor.name:teleport(get_room(118, 34))
elseif rm == 4 then
    actor.name:teleport(get_room(118, 35))
elseif rm == 5 then
    local dest = 43144 + random(1, 13)
    actor.name:teleport(get_room(vnum_to_zone(dest), vnum_to_local(dest)))
elseif rm == 6 then
    actor.name:teleport(get_room(101, 0))
elseif rm == 7 then
    actor.name:teleport(get_room(551, 5))
elseif rm == 8 then
    actor.name:teleport(get_room(325, 89))
elseif rm == 9 then
    actor.name:teleport(get_room(127, 1))
end  -- auto-close switch