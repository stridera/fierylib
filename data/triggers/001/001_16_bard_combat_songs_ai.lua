-- Trigger: Bard combat songs AI
-- Zone: 1, ID: 16
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #116
-- Converted from DG Script #116: Bard combat songs AI
-- Original: MOB trigger, flags: FIGHT, probability: 100%
--
-- 5s cooldowns are tracked on per-mob globals so each mob retries
-- periodically rather than spamming every fight tick.

local now_ts = timestamp()

if self.level >= 10 then
    if not globals.terror_at or (now_ts - globals.terror_at >= 5) then
        if not actor:get_has_spell("terror") and not actor:get_has_spell("ballad of tears") then
            self:perform("terror", actor, self.level)
            globals.terror_at = now_ts
        end
    end
end

if self.level >= 70 then
    if not globals.ballad_at or (now_ts - globals.ballad_at >= 5) then
        if actor.group_size and actor.group_size > 1 then
            for _, person in ipairs(self.room.people) do
                if person.is_player then
                    if not self:get_has_spell("terror") and not self:get_has_spell("ballad of tears") then
                        self:perform("ballad of tears", person, self.level)
                        globals.ballad_at = now_ts
                        return true
                    end
                end
            end
        end
    end
end
