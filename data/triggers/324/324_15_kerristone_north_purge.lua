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
if actor.zone_id == 324 and actor.local_id == 21 then
    wait(1)
    world.destroy(actor)
end
if actor.zone_id == 324 and actor.local_id == 23 then
    wait(1)
    world.destroy(actor)
end