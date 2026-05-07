-- Trigger: wandering minstrel fight
-- Zone: 489, ID: 31
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Wandering-minstrel combat AI with a 5-tick cooldown:
--   * level >= 70: AOE 'ballad of tears' on the whole group
--   * level >= 10: single-target 'terror' on the current attacker
-- Skips when silenced or when the target is already affected.

if (actor.id >= 48900) and (actor.id <= 48999) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("wandering-minstrel"):heal(1000)
    end)
end
if self:get_eff_flagged("silence") then
    return true
end

-- TODO(parity): cooldown originally tracked via per-trigger globals `now`/
-- `now2`. We collapsed both into a single 5-tick gate keyed by
-- `globals.minstrel_song_cooldown`; revisit if the level branches need
-- independent cadence.
local cooldown = globals.minstrel_song_cooldown
if cooldown and (timestamp() - cooldown < 5) then
    return true
end

if self.level >= 70 then
    if actor.group_size and actor.group_size > 1 then
        local person = self.room.people
        while person do
            if person.is_player and not person:get_has_spell("terror") and not person:get_has_spell("ballad of tears") then
                self:perform("ballad of tears", person, self.level)
                globals.minstrel_song_cooldown = timestamp()
                return true
            end
            person = person.next_in_room
        end
    end
elseif self.level >= 10 then
    if actor and not actor:get_has_spell("terror") and not actor:get_has_spell("ballad of tears") then
        self:perform("terror", actor, self.level)
        globals.minstrel_song_cooldown = timestamp()
    end
end
