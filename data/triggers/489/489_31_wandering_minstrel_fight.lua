-- Trigger: wandering minstrel fight
-- Zone: 489, ID: 31
-- Type: MOB, Flags: FIGHT
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #48931

-- Converted from DG Script #48931: wandering minstrel fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if (actor.id >= 48900) &(actor.id <= 48999) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("wandering-minstrel"):heal(1000)
    end)
end
if self:get_eff_flagged("silence") then
    return _return_value
end
if self.level >= 70 then
    if (now2 and (time.stamp - now2 >= 5)) or not now2 then
        if actor.group_size > 1 then
            local room = self.room
            local person = room.people
            while person do
                if person.id == -1 then
                    if not self:get_has_spell("terror") and not self:get_has_spell("ballad of tears") then
                        self:perform("ballad of tears", person, self.level)
                        local now2 = time.stamp
                        globals.now2 = globals.now2 or true
                        return _return_value
                    end
                end
                local person = person.next_in_room
            end
        end
    end
elseif self.level >= 10 then
    if (now and (time.stamp - now >= 5)) or not now then
        if not actor:get_has_spell("terror") and not actor:get_has_spell("ballad of tears") then
            self:perform("terror", actor, self.level)
            local now = time.stamp
            globals.now = globals.now or true
        end
    end
end