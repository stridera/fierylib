-- Trigger: scepter_reform
-- Zone: 188, ID: 22
-- Type: OBJECT, Flags: GLOBAL, WEAR
-- Status: CLEAN
--
-- Original DG Script: #18822

-- Converted from DG Script #18822: scepter_reform
-- Original: OBJECT trigger, flags: GLOBAL, WEAR, probability: 100%
if ((self.zone_id == 188 and self.id == 22) and actor:has_equipped(188, 23)) or ((self.zone_id == 188 and self.id == 23) and actor:has_equipped(188, 22)) then
    wait(0.1)
    self.room:send_except(actor, tostring(actor.name) .. " places the ruby in the mouth of the scepter's dragon.")
    actor:send("You place the ruby in the mouth of the dragon.")
    self.room:send("The ruby flares, and the scepter begins to glow <red>red</>.")
    wait(1)
    self.room:send_except(actor, tostring(actor.name) .. " yelps as the scepter burns " .. tostring(actor.object) .. ", dropping it!")
    actor:send("The scepter burns you, and you drop it!")
    if (self.zone_id == 188 and self.id == 22) then
        world.destroy(self.room:find_object("ruby-duclia"))
    elseif (self.zone_id == 188 and self.id == 23) then
        world.destroy(self.room:find_object("scepter-duclia"))
    end
    self.room:spawn_object(188, 24)
    world.destroy(self)
end