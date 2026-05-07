-- Trigger: Transfer trig, 49531
-- Zone: 495, ID: 2
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #49502
-- Bounces dark-aligned shadow classes (Necromancer, Anti-Paladin, Thief,
-- Assassin, Mercenary) westward into the temple's inner sanctum, otherwise
-- ejects the wanderer to a safer locale.

-- Command filter: west / w
if not (cmd == "west" or cmd == "w") then
    return true  -- Not our command
end

if not actor.is_player then
    return true
end

local class = actor.class or ""
local is_shadow_class = string.find(class, "Necromancer")
    or string.find(class, "Anti-Paladin")
    or string.find(class, "Thief")
    or string.find(class, "Assassin")
    or string.find(class, "Mercenary")

if not is_shadow_class then
    return true
end

if actor.alignment < -349 then
    actor:send("Reality blurs and melts as you find yourself in a more dark and confined place.")
    actor:teleport(get_room(495, 33))
else
    actor:send("A cloak of shadow surrounds your being, choking your very breathe. Now you awake elsewhere.")
    actor:teleport(get_room(30, 2))
end
