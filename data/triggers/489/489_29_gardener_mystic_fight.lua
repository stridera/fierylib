-- Trigger: gardener mystic fight
-- Zone: 489, ID: 29
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48929

-- Converted from DG Script #48929: gardener mystic fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if (actor.id >= 48900) and (actor.id <= 48999) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("gardener-mystic"):heal(1000)
    end)
end