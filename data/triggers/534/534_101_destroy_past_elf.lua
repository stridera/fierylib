-- Trigger: Destroy past elf
-- Zone: 534, ID: 101
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #53501

-- Converted from DG Script #53501: Destroy past elf
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- TODO(parity): legacy DG checked actor vnum range 53500-53508 (the past-elf
-- mob illusions in zone 535). actor.id is now the local id within actor.zone_id;
-- replace with the appropriate composite check once mob protos migrate. Best
-- guess: zone_id == 535 and local_id in 0..8.
if actor.zone_id == 535 and actor.id >= 0 and actor.id <= 8 then
    actor:send("You can't go that way!")
end
return true