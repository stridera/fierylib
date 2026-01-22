-- Trigger: sunchild fight
-- Zone: 489, ID: 26
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48926

-- Converted from DG Script #48926: sunchild fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local chance = random(1, 10)
if (actor.id >= 48900) and (actor.id <= 48999) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("sunchild"):heal(1000)
    end)
elseif chance <= 2 then
    wait(2)
    self.room:send("<yellow>A Sunchild <blue>flares brightly</><yellow>, casting rays of <white>light<yellow> everywhere!</>")
    local room = self.room
    local person = room.people
    while person do
        if person.id == -1 then
            spells.cast(self, "sunray", person, 100)
        end
        local person = person.next_in_room
    end
end