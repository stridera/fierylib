-- Trigger: severan shockwave
-- Zone: 489, ID: 33
-- Type: WORLD, Flags: GLOBAL
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #48933

-- Converted from DG Script #48933: severan shockwave
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("<b:white>The white aura around Severan's body intensifies, increasing in brightness.</>")
wait(2)
self.room:send("<b:white>A powerful shockwave leaps off Severan's body as the aura flares wildly!</>")
local casters = "Sorcerer Necromancer Cryomancer Pyromancer Cleric Druid Diabolist Priest Shaman Conjurer"
local person = self.people
while person do
    local next = person.next_in_room
    if ((person.id < 48900) or (person.id > 48999)) &(person.level < 100) then
        if string.find(casters, "person.class") then
            local damage = 100 + random(1, 50)
        else
            local damage = 250 + random(1, 50)
        end
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
        -- Halve damage AGAIN for major globe
        local globed = person:has_effect(Effect.Major_Globe)
        if globed then
            local damage = damage / 2
        end
        local damage_dealt = person:damage(damage)  -- type: crush
        if damage_dealt == 0 then
            self.room:send_except(person, "<b:white>The blast passes through " .. tostring(person.name) .. ", causing no damage.</>")
            person:send("<b:white>The blast passes through you harmlessly.</>")
        elseif globed then
            self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body wavers as the blast overwhelms it!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<b:red>The <white>blast<red> passes through the shimmering globe around your body, striking you!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        else
            self.room:send_except(person, "<b:white>The blast strikes " .. tostring(person.name) .. " violently, tearing at " .. tostring(person.possessive) .. " flesh!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<b:white>The blast strikes you violently, rending your flesh!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
    local person = next
end