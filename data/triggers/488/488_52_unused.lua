-- Trigger: **UNUSED** (invoked from 488/06 stormchild_fight via run_room_trigger)
-- Zone: 488, ID: 52
-- Type: WORLD, Flags: GLOBAL
-- Status: REVIEWED
--
-- Original DG Script: #48852
--
-- Behavior: Stormchild thunder wave AoE. Damages everyone in the room except
-- mobs from the zone's own NPC pool (the legacy 48800-48899 range; in the
-- composite-id world that maps to zone 488). Sanctuary halves; stoneskin
-- doubles damage and shatters with bespoke flavor.
self.room:send("The Stormchild opens her mouth in a scream, and a wave of thunder rolls out!")
for _, person in ipairs(self.room.actors) do
    -- Skip the zone's own NPC mobs (allies / the boss herself).
    if person.is_player or person.zone_id ~= 488 then
        local damage = 150 + random(1, 50)
        -- Halve damage for sanc
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            -- Double damage for stoneskin
            damage = damage + damage
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
end