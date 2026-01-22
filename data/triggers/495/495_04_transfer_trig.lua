-- Trigger: Transfer trig
-- Zone: 495, ID: 4
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #49504

-- Converted from DG Script #49504: Transfer trig
-- Original: WORLD trigger, flags: COMMAND, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Command filter: east e
if not (cmd == "east" or cmd == "e") then
    return true  -- Not our command
end
if actor.id == -1 then
    if string.find(actor.class, "Priest") or actor.class == "Cleric" or actor.class == "Paladin" or actor.class == "Ranger" or actor.class == "Monk" or actor.class == "Druid" then
        if actor.alignment < 350 then
            actor:send("You have no business here in the realm of shadow and death.")
            actor:send("You find yourself in a lighter place at peace.")
            actor:teleport(get_room(30, 2))
        end
    end
end