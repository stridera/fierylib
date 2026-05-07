-- Trigger: guardian_of_book
-- Zone: 510, ID: 9
-- Type: OBJECT, Flags: GET
--
-- Original DG Script: #51009
-- When the book of Nordus is picked up anywhere inside zone 510, an
-- unworthy-handler guardian (510, 25) spawns into the actor's room
-- and engages them. Latched by `alreadyrun` so the guardian can't
-- multiply if the player drops and re-grabs; cleared by 510_10
-- (guardian_of_book_reset) on DROP.

if alreadyrun == 1 then
    return true
end
if actor.room.zone_id ~= 510 then
    return true
end

actor.room:spawn_mobile(510, 25)
local guardian = actor.room:find_actor("guardian")
if guardian then
    guardian:say("You are not worthy to handle the book of Nordus!")
    guardian:command("hit " .. tostring(actor.name))
end
globals.alreadyrun = 1
