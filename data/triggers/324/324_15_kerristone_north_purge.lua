-- Trigger: Kerristone_north_purge
-- Zone: 324, ID: 15
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #32415

-- Converted from DG Script #32415: Kerristone_north_purge
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: purge_me
if not (cmd == "purge_me") then
    return true  -- Not our command
end
-- this is a room purge to see if a world
-- purge will dump a mobile as mpurge %self%
-- seems broken
if actor.id == 32421 then
    wait(1)
    world.destroy(actor)
else
end
if actor.id == 32423 then
    wait(1)
    world.destroy(actor)
else
end