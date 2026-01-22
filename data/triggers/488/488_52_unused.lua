-- Trigger: **UNUSED**
-- Zone: 488, ID: 52
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48852

-- Converted from DG Script #48852: **UNUSED**
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("The Stormchild opens her mouth in a scream, and a wave of thunder rolls out!")
local person = self.people
while person do
    local next = person.next_in_room
    if (person.id < 48800) or (person.id > 48899) then
        local damage = 150 + random(1, 50)
        -- Halve damage for sanc
        if person:has_effect(Effect.Sanctuary) then
            local damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            -- Double damage for stoneskin
            local damage = damage + damage
        end
        local damage_dealt = person:damage(damage)  -- type: crush
        if damage_dealt == 0 then
            person:send("The blast passes through you harmlessly.")
            self.room:send_except(person, "The blast passes harmlessly through " .. tostring(person.name) .. ".")
        elseif person:has_effect(Effect.Stone) then
            self.room:send_except(person, "<yellow>" .. tostring(person.name) .. " writhes in agony as the thunder shatters " .. tostring(person.possessive) .. " stony skin!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<yellow>You writhe in agony as the thunder shatters your stony skin!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        else
            self.room:send_except(person, "<yellow>" .. tostring(person.name) .. " cries out in pain as the thunderclap pounds " .. tostring(person.possessive) .. " eardrums!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<yellow>You cry out in pain as the thunderclap pounds your eardrums!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
    local person = next
end