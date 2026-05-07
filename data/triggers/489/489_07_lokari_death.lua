-- Trigger: lokari death
-- Zone: 489, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48907

-- Converted from DG Script #48907: lokari death
-- Original: MOB trigger, flags: DEATH, probability: 100%
--
-- Lokari banishes himself, drops the glass-shard for the body-loader, and
-- awards the shift-corpse spell to anyone in his group at quest stage 2.
self.room:send("Lokari's form dissipates, banished from this realm.")
self.room:send(tostring(objects.template(489, 14).name) .. " falls from Lokari's hand as he disappears.")
self:destroy_item("glass-shard")
run_room_trigger(489, 16)

local function award_shift_corpse(person)
    if not person or person.room ~= self.room then
        return
    end
    if person:get_quest_stage("shift_corpse") ~= 2 then
        return
    end
    self.room:send("<blue>&9Swirling energy as black as the moonless night slithers from " .. tostring(objects.template(62, 28).name) .. ".<blue>&9")
    person:send("<blue>&9It fills you with limitless arcane power as it forces its way into your body!</>")
    person:send("<blue>&9Your awareness of death now stretches beyond the boundaries of the planes themselves!</>")
    self.room:send_except(person, "<blue>&9It forces its way into " .. tostring(person.name) .. "'s body!</>")
    person:complete_quest("shift_corpse")
    skills.set_level(person.name, "shift corpse", 100)
end

if actor and actor.group and #actor.group > 0 then
    for _, person in ipairs(actor.group) do
        award_shift_corpse(person)
    end
else
    award_shift_corpse(actor)
end
self:teleport(get_room(11, 0))
return true