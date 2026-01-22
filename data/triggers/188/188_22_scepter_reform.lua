-- Trigger: scepter_reform
-- Zone: 188, ID: 22
-- Type: OBJECT, Flags: GLOBAL, WEAR
-- Status: CLEAN
--
-- Original DG Script: #18822

-- Converted from DG Script #18822: scepter_reform
-- Original: OBJECT trigger, flags: GLOBAL, WEAR, probability: 100%
if (self.id == 18822 and actor:has_equipped("18823")) or (self.id == 18823 and actor:has_equipped("18822")) then
    wait(1)
    self.room:send_except(actor, tostring(actor.name) .. " places the ruby in the mouth of the scepter's dragon.")
    actor:send("You place the ruby in the mouth of the dragon.")
    self.room:send("The ruby flares, and the scepter begins to glow <red>red</>.")
    wait(1)
    self.room:send_except(actor, tostring(actor.name) .. " yelps as the scepter burns " .. tostring(actor.object) .. ", dropping it!")
    actor:send("The scepter burns you, and you drop it!")
    if self.id == 18822 then
        world.destroy(self.room:find_object("ruby-duclia"))
    elseif self.id == 18823 then
        world.destroy(self.room:find_object("scepter-duclia"))
    end
    self.room:spawn_object(188, 24)
    world.destroy(self)
end