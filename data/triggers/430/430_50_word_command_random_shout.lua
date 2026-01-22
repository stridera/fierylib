-- Trigger: word_command_random_shout
-- Zone: 430, ID: 50
-- Type: WORLD, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #43050

-- Converted from DG Script #43050: word_command_random_shout
-- Original: WORLD trigger, flags: GLOBAL, RANDOM, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
if world.count_mobiles("43021") == 0 then
    zone.echo(430, "Someone shouts, 'Help!  Can anyone hear me?!  I'm trapped in the maze!  Help!!'")
end