-- Trigger: titan fight
-- Zone: 486, ID: 37
-- Type: MOB, Flags: FIGHT
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #48637

-- Converted from DG Script #48637: titan fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local action = random(1, 10)
if action > 7 then
    -- 30% chance to punch the tank
    wait(2)
    if actor and (actor.room == self.room) and (actor.id == -1) then
        local damage = 300 + random(1, 50)
        if actor:has_effect(Effect.Sanctuary) then
            local damage = damage / 2
        end
        if actor:has_effect(Effect.Stone) then
            local damage = damage / 2
        end
        -- Chance for critical hit
        local variant = random(1, 15)
        if variant == 1 then
            local damage = damage - 100
        elseif variant == 15 then
            local damage = damage + 200
        end
        if damage > 0 then
            local damage_dealt = actor:damage(damage)  -- type: crush
            self.room:send_except(actor, tostring(self.name) .. " punches " .. tostring(actor.name) .. " in the face, giving " .. tostring(actor.object) .. " a black eye. (<yellow>" .. tostring(damage_dealt) .. "</>)")
            actor:send(tostring(self.name) .. " punches you in the face. (<b:red>" .. tostring(damage_dealt) .. "</>)")
        else
            self.room:send_except(actor, tostring(self.name) .. " tries to punch " .. tostring(actor.name) .. " in the face, but can't seem to make contact.")
            actor:send(tostring(self.name) .. " tries to punch you, but can't seem to make contact.")
        end
    end
elseif action > 4 then
    -- 30% chance to try to blind the room
    wait(1)
    self:emote("clasps " .. tostring(objects.template(484, 24).name) .. " in his giant hands.")
    self.room:send(tostring(objects.template(484, 24).name) .. " begins to <blue>glow</> brightly.")
    wait(2)
    self.room:send(tostring(objects.template(484, 24).name) .. " flares brightly, throwing blinding light in all directions!")
    local room = self.room
    local person = room.people
    while person do
        if person.id == -1 then
            spells.cast(self, "blindness", person, 100)
        end
        local person = person.next_in_room
    end
end
-- 40% chance to do nothing