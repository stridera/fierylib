-- Trigger: megalith_quest_ritual_effects1
-- Zone: 123, ID: 17
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #12317

-- Converted from DG Script #12317: megalith_quest_ritual_effects1
-- Original: WORLD trigger, flags: GLOBAL, probability: 0%

-- Runs only through run_room_trigger() (DG probability 0 = never automatic); the converter's
-- percent_chance(0) guard blocked those calls.
wait(0.2)
zone.echo(123, "The Keepers call out, 'Great Lady of the Stars, hear our prayer!'")
wait(0.2)
zone.echo(123, "The voices of the coven call out in unison, 'Great Lady of the Stars, hear our prayer!'")