-- Trigger: keep servant fight
-- Zone: 489, ID: 28
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48928

-- Converted from DG Script #48928: keep servant fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if (actor.id >= 48900) and (actor.id <= 48999) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("keep-servant"):heal(1000)
    end)
end