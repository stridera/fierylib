-- Trigger: mighty druid creeping doom
-- Zone: 484, ID: 103
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48503

-- Converted from DG Script #48503: mighty druid creeping doom
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
for _, person in ipairs(self:get_people()) do
    if (person.zone_id ~= 484 or person.id < 100 or person.id > 199) then
        local damage = 190 + random(1, 20)
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            damage = damage / 2
        end
        self.room:send("<b:black>The mighty druid sends out an endless wave of crawling </><red>arachnoids<b:black> and </><green>insects<b:black> to consume his foes!</> (<b:red>" .. tostring(damage) .. "</>)")
        local damage_dealt = person:damage(damage)  -- type: physical
    end
end