-- Trigger: Ill-subclass: Drop the vial
-- Zone: 172, ID: 6
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Player drops the vial of disturbance. If they're inside the smuggler's
-- hideout (zone 363 rooms 15..39) at quest stage 1, the gas builds and the
-- quest advances. If a conscious smuggler witnesses the drop the quest
-- branches: the leader (Gannigan, mob 363:1) calls the player out, the
-- chief (363:6) snorts, lesser smugglers (363:0/3/4) tattle - all of these
-- bump the quest one extra stage to mark the player as suspected.
--
-- The vial is consumed regardless of outcome. We always return false so
-- the underlying drop is suppressed (the object is destroyed instead).
--
-- Original DG Script: #17206

wait(1)
local room_zone = actor.room.zone_id
local room_id = actor.room.local_id
local in_hideout = room_zone == 363 and room_id >= 15 and room_id <= 39

if not (in_hideout and actor:get_quest_stage("illusionist_subclass") == 1) then
    self.room:send("The vial breaks easily, and a small gray puff of gas quickly disperses.")
    self.room:send("A sense of magic is felt, but it quickly fades.")
    self.room:send("It appears as though something has gone wrong.")
    world.destroy(self)
    return false
end

self.room:send("The vial breaks easily, and the small gray puff of gas quickly disperses.")
self.room:send("As the moments pass, you sense a magical tension building.")
self.room:send("It spreads outward as its strength grows.")
actor:advance_quest("illusionist_subclass")

-- Scan the room for any smuggler who could have noticed.
local smuggler_found = false
local chief_found = false
local leader_found = false
local person = self.room.people
while person do
    local incapacitated = person:has_effect(Effect.Blind)
        or string.find(person.stance or "", "mortally")
        or string.find(person.stance or "", "incapacitated")
        or string.find(person.stance or "", "stunned")
        or string.find(person.stance or "", "sleeping")
    if not incapacitated and person.zone_id == 363 then
        if person.local_id == 0 or person.local_id == 3 or person.local_id == 4 then
            smuggler_found = true
        elseif person.local_id == 6 then
            chief_found = true
            smuggler_found = true
        elseif person.local_id == 1 then
            leader_found = true
            smuggler_found = true
        end
    end
    person = person.next_in_room
end

if leader_found then
    wait(1)
    local gannigan = self.room:find_actor("gannigan")
    if gannigan then
        gannigan:command("gasp")
        gannigan:say("Cestia... what on earth are you doing?")
    end
elseif chief_found then
    wait(1)
    local chief = self.room:find_actor("chief")
    if chief then
        chief:say("Hrnn?  Irksome wench!  Gannigan shall hear of this!")
    end
elseif smuggler_found then
    wait(1)
    local smuggler = self.room:find_actor("smuggler")
    if smuggler then
        smuggler:emote("looks somewhat confused, but also suspicious.")
        smuggler:say("Hey... ummm...  I'd better let the big guy know you're up to something...  No offense ma'am, but that didn't look too innocent.")
    end
end

if smuggler_found then
    actor:advance_quest("illusionist_subclass")
end

world.destroy(self)
return false