-- Trigger: drop_sapling
-- Zone: 490, ID: 2
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #49002

-- Converted from DG Script #49002: drop_sapling
-- Original: WORLD trigger, flags: DROP, probability: 100%
-- The sapling is dropped. If Dagon is present, it will grow and destroy
-- the altar, weakening him.
if object.id == 49045 and self:get_people("49021") then
    wait(1)
    self.room:send("The sapling vibrates faster and faster and its roots start to grow!")
    self.room:send("Even as you watch, the sapling moves towards the altar and starts to grow into it.")
    world.destroy(self.room:find_actor("sapling"))
    world.destroy(self.room:find_actor("griffin-altar"))
    self.room:spawn_object(490, 44)
    wait(1)
    self.room:send("CRACK!")
    wait(1)
    self.room:send("The altar has been broken by the sapling!")
    self.room:find_actor("dagon"):emote("shrieks in rage and pain as the source of his power is destroyed.")
    self.room:find_actor("dagon"):command("dagonisweaknow")
end