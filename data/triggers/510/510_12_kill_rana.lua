-- Trigger: kill_rana
-- Zone: 510, ID: 12
-- Type: WORLD, Flags: PREENTRY
--
-- Original DG Script: #51012
-- Fires when mob (510, 10) — Rana, carrying the petrified magic —
-- enters this room. A magical apparition mocks her, then deals
-- 10,000 damage to her, demonstrating that the protection is a sham.

if not (actor.zone_id == 510 and actor.id == 10) then
    return true
end

wait(1)
self.room:send("An large image of a face appears in the room.")
local rana = self.room:find_actor("rana")
if rana then
    rana:say("I'll kill you Luchiaans, but slowly")
end
self.room:send(tostring(actor.name) .. " waves the petrified magic defiantly.")
if rana then
    rana:say("This will protect me against you.")
end
wait(5)
self.room:send("The aparition laughs and says a couple of words.")
actor:damage(10000)
self.room:send("The aparition chuckles and says, 'Well, HE underestimated my power bigtime.'")
wait(5)
self.room:send("The aparition fades.")
