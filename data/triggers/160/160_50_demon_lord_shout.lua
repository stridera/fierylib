-- Trigger: demon_lord_shout
-- Zone: 160, ID: 50
-- Type: WORLD, Flags: GLOBAL
--
-- Zone-wide announcement fired from the storm demon's death trigger
-- (160,24) — once the demon lord has been summoned, every player in
-- Mystwatch hears him challenge the intruders.

zone.echo(160, "The Demon Lord shouts 'Who DARES to disturb my realm?!'")
