-- Trigger: megalith_quest_ritual_effects2
-- Zone: 123, ID: 18
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #12318

-- Converted from DG Script #12318: megalith_quest_ritual_effects2
-- Original: WORLD trigger, flags: GLOBAL, probability: 0%

-- Runs only through run_room_trigger() (DG probability 0 = never automatic); the converter's
-- percent_chance(0) guard blocked those calls.
wait(0.2)
zone.echo(123, "The coven chants, 'We summon and stir thee!'")
wait(1)
zone.echo(123, "<green>The harmonic rumbling intensifies as the ground starts to shake as if awakening.</>")