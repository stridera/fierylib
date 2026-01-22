-- Trigger: mighty druid creeping doom
-- Zone: 485, ID: 3
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48503

-- Converted from DG Script #48503: mighty druid creeping doom
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local person = self.people
while person do
    local next = person.next_in_room
    if (person.id < 48500) or (person.id > 48599) then
        local damage = 190 + random(1, 20)
        if person:has_effect(Effect.Sanctuary) then
            local damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            local damage = damage / 2
        end
        self.room:send("<blue>&9The mighty druid sends out an endless wave of crawling </><red>arachnoids<blue>&9 and </><green>insects<blue>&9 to consume his foes!</> (<b:red>" .. tostring(damage) .. "</>)")
        local damage_dealt = person:damage(damage)  -- type: physical
    end
    local person = next
end