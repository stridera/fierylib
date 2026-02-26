-- Trigger: Balor_death_damage
-- Zone: 22, ID: 1
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2201

-- Converted from DG Script #2201: Balor_death_damage
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local person = self.people
while person do
    local next = person.next_in_room
    if person.id ~= 2216 then
        local damage = 100 + random(1, 50)
        local damage_dealt = person:damage(damage)  -- type: fire
        person:send("The Balor explodes in a <b:yellow>blinding</> flash, scorching the area! (<b:red>" .. tostring(damage_dealt) .. "</>)")
    end
    local person = next
end
wait(2)
self.room:send("<b:white>As the smoke <white>subsides, a stairway down appears.</>")
get_room(22, 15):exit("down"):set_state({hidden = false})
get_room(22, 15):exit("down"):set_state({description = "Down the stairs, there is a faint sound of cheering..."})