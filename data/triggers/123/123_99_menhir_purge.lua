-- Trigger: menhir_purge
-- Zone: 123, ID: 99
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12399

-- Converted from DG Script #12399: menhir_purge
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if self:get_objects("12350") and self:get_objects("12351") then
    world.destroy(self.room:find_actor("awakened-menhir"))
    self.room:send(tostring(objects.template(123, 50).name) .. " gradually stops glowing and falls silent.")
end