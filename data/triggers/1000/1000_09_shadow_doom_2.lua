-- Trigger: Shadow Doom 2
-- Zone: 0, ID: 9
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #9
-- If given the correct badge, escort the player to the Shadow Doom hall;
-- otherwise reject and drop the offering.

if object.zone_id == 90 and object.local_id == 36 then
    wait(5)
    actor:send("The </>&9<blue>Shadow Doom</> guard grins wickedly, and escourts you from the hall.</>")
    actor:teleport(get_room(91, 20))
    self.room:send_except(actor, tostring(actor.name) .. " is thrown out from the </>&9<blue>Shadow Doom</> hall.</>")
else
    wait(5)
    self:say("What the hell is this?!")
    self:command("drop " .. tostring(object.name))
end
return true
