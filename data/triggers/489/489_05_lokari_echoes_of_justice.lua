-- Trigger: lokari echoes of justice
-- Zone: 489, ID: 5
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48905

-- Converted from DG Script #48905: lokari echoes of justice
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local majorglobe = "MAJOR_GLOBE"
self.room:send("Lokari starts casting <b:yellow>'echoes of justice'</>...")
wait(1)
self.room:send("Lokari utters the words, 'sdorj lp kandiso'.")
self.room:send("<green>Lokari's justice spreads through the room, striking down trespassers!</>")
local person = self.people
while person do
    local next = person.next_in_room
    if person and ((person.id < 48900) or (person.id > 48999)) and (person.level < 100) then
        local damage = 150 + random(1, 100)
        if person:has_effect(Effect.Sanctuary) then
            local damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            local damage = damage / 2
        end
        -- Chance for critical hit
        local variant = random(1, 15)
        if variant == 1 then
            local damage = damage / 2
        elseif variant == 15 then
            local damage = damage * 2
        end
        local globed = person:has_effect(Effect.Major_Globe)
        if globed then
            local damage = damage / 2
            self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body wavers under </><yellow>Lokari's justice<b:red>.</> (<blue>" .. tostring(damage) .. "</>)")
            person:send("<b:red>You shiver as </><yellow>Lokari's justice<b:red> rips through the shimmering globe around your body, striking you!</> (<b:red>" .. tostring(damage) .. "</>)")
        else
            self.room:send_except(person, "<yellow>" .. tostring(person.name) .. " slumps under the knowledge of " .. tostring(person.possessive) .. " own wrongdoing.</> (<blue>" .. tostring(damage) .. "</>)")
            person:send("<yellow>You slump under the knowledge of your own wrongdoing.</> (<b:red>" .. tostring(damage) .. "</>)")
        end
        local damage_dealt = person:damage(damage)  -- type: physical
    end
    local person = next
end