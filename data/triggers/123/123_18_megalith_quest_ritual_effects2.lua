-- Trigger: megalith_quest_ritual_effects2
-- Zone: 123, ID: 18
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #12318

-- Converted from DG Script #12318: megalith_quest_ritual_effects2
-- Original: WORLD trigger, flags: GLOBAL, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
wait(2)
zone.echo(123, "The coven chants, 'We summon and stir thee!'")
wait(1)
zone.echo(123, "<green>The harmonic rumbling intensifies as the ground starts to shake as if awakening.</>")