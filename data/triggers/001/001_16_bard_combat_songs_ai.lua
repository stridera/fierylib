-- Trigger: Bard combat songs AI
-- Zone: 1, ID: 16
-- Type: MOB, Flags: FIGHT
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #116

-- Converted from DG Script #116: Bard combat songs AI
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if self.level >= 10 then
    if (now and (time.stamp - now >= 5)) or not now then
        if not actor:get_has_spell("terror") and not actor:get_has_spell("ballad of tears") then
            self:perform("terror", actor, self.level)
            local now = time.stamp
            globals.now = globals.now or true
        end
    end
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
end