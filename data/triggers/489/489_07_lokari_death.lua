-- Trigger: lokari death
-- Zone: 489, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48907

-- Converted from DG Script #48907: lokari death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send("Lokari's form dissipates, banished from this realm.")
self.room:send(tostring(objects.template(489, 14).name) .. " falls from Lokari's hand as he disappears.")
self:destroy_item("glass-shard")
run_room_trigger(48916)
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("shift_corpse") == 2 then
                self.room:send("<blue>&9Swirling energy as black as the moonless night slithers from " .. tostring(objects.template(62, 28).name) .. ".<blue>&9")
                person:send("<blue>&9It fills you with limitless arcane power as it forces its way into your body!</>")
                person:send("<blue>&9Your awareness of death now stretches beyond the boundaries of the planes themselves!</>")
                self.room:send_except(person, "<blue>&9It forces its way into " .. tostring(person.name) .. "'s body!</>")
                person.name:complete_quest("shift_corpse")
                skills.set_level(person.name, "shift corpse", 100)
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif actor:get_quest_stage("shift_corpse") == 2 then
    self.room:send("<blue>&9Swirling energy as black as the moonless night slithers from " .. tostring(objects.template(62, 28).name) .. ".<blue>&9")
    actor:send("<blue>&9It fills you with limitless arcane power as it forces its way into your body!</>")
    actor:send("<blue>&9Your awareness of death now stretches beyond the boundaries of planes themselves!</>")
    self.room:send_except(actor, "<blue>&9It forces its way into " .. tostring(actor.name) .. "'s body!</>")
    actor.name:complete_quest("shift_corpse")
    skills.set_level(actor.name, "shift corpse", 100)
end
self:teleport(get_room(11, 0))
return _return_value