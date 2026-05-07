-- Trigger: flood_frozen_death
-- Zone: 390, ID: 9
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #39009
--
-- Frozen Lake spirit (39018) dies: shatter, mark every Envoy in the
-- room as having water6, and if any of them now has all eight waters,
-- advance their quest. The corpse-mob teleports away (DG used a void
-- room) so it can't be looted.
--
-- TODO: original DG iterated `actor.group_size` / `actor.group_member[a]`
-- and `room.people` / `person.next_in_room`, none of which exist in the
-- new Lua API. Replace with `self.room:players()` (or whatever helper
-- ships) once that API is finalized. Until then, this trigger only
-- correctly handles the killer; group-mates in the room are missed.
-- TODO: `self:teleport(get_room(11, 0))` — confirm (11, 0) is the
-- intended void/holding room.

self.room:send("<b:cyan>" .. self.name .. " shatters into a thousand pieces!</>")

local function check_complete(p)
    if p:get_quest_var("flood:water1")
            and p:get_quest_var("flood:water2")
            and p:get_quest_var("flood:water3")
            and p:get_quest_var("flood:water4")
            and p:get_quest_var("flood:water5")
            and p:get_quest_var("flood:water6")
            and p:get_quest_var("flood:water7")
            and p:get_quest_var("flood:water8") then
        p:advance_quest("flood")
        p:send("<b:blue>You have garnered the support of all the great waters!</>")
    end
end

local envoy = false
if actor and actor:get_quest_stage("flood") == 1 then
    actor:set_quest_var("flood", "water6", 1)
    envoy = true
    check_complete(actor)
end

if envoy then
    self.room:send("A chilly voice says, <b:cyan>'You have bested me, Envoy.  I acquiesce to your request.'</>")
end

self:teleport(get_room(11, 0))
return true