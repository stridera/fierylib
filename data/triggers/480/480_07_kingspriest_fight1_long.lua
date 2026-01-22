-- Trigger: kingspriest_fight1_long
-- Zone: 480, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48007

-- Converted from DG Script #48007: kingspriest_fight1_long
-- Original: MOB trigger, flags: DEATH, probability: 100%
if actor.id == -1 then
    self:shout("You will never truely defeat me!")
    self.room:send("<yellow>The Undead KingPriest throws up his head and</> <b:yellow>his eyes</> <b:red>glow</> <b:white>white</> <yellow>with rage!</>")
    self:teleport(get_room(480, 84))
    self:destroy_item("hammer")
    self.room:spawn_mobile(480, 27)
    self.room:find_actor("wraith"):spawn_object(480, 2)
    self.room:find_actor("wraith"):spawn_object(480, 36)
    self.room:find_actor("wraith"):command("wear all")
    self.room:spawn_mobile(480, 28)
    self.room:spawn_mobile(480, 28)
    self.room:spawn_mobile(480, 28)
    self.room:find_actor("wraith"):teleport(get_room(480, 45))
    self.room:find_actor("shadow-guardian"):teleport(get_room(480, 45))
    self.room:find_actor("shadow-guardian"):teleport(get_room(480, 45))
    self.room:find_actor("shadow-guardian"):teleport(get_room(480, 45))
    self:teleport(get_room(480, 45))
    self.room:send("<yellow>The Undead KingPriest Cracks in</> <b:red>two,</> <b:white>split open by a white light.</>")
    self.room:send("<yellow>From the shell emerges the</> <b:cyan>Wraith of the KingPriest!</>")
    self.room:find_actor("wraith"):shout("Come to me my guardians!  We have souls to claim!")
    self.room:send("<b:green>The stone of the floor and wall erupt into statues of shadowy guardians!</>")
    self.room:find_actor("wraith"):command("kill %actor.name%")
    self.room:find_actor("shadow"):command("kill %actor.name%")
    self.room:find_actor("2.shadow"):command("kill %actor.name%")
    self.room:find_actor("3.shadow"):command("kill %actor.name%")
    self:teleport(get_room(480, 84))
else
end