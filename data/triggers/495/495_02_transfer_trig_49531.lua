-- Trigger: Transfer trig, 49531
-- Zone: 495, ID: 2
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #49502

-- Converted from DG Script #49502: Transfer trig, 49531
-- Original: WORLD trigger, flags: COMMAND, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Command filter: west w
if not (cmd == "west" or cmd == "w") then
    return true  -- Not our command
end
if actor.id == -1 then
    if string.find(actor.class, "Necromancer") or Anti-Paladin or Thief or Assassin or Mercenary then
        if actor.alignment < -349 then
            actor:send("Reality blurs and melts as you find yourself in a more dark and confined place.")
            actor:teleport(get_room(495, 33))
        else
            actor:send("A cloak of shadow surrounds your being, choking your very breathe. Now you awake elsewhere.")
            actor:teleport(get_room(30, 2))
        end
    end
end