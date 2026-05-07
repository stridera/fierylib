-- Trigger: Room 1888 - massive harming
-- Zone: 18, ID: 2
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1802

-- Converted from DG Script #1802: Room 1888 - massive harming
-- Original: WORLD trigger, flags: SPEECH, probability: 100%
-- This script is invoked programmatically from trigger 1801 (random room trigger).
-- The original DG keyword line was a parenthetical comment, not real keywords; the
-- intent is to fire whenever this trigger runs (speech-or-call), then damage all
-- players in the room.
-- Damage all players in the room
-- Note: self is a Room for WORLD triggers
for _, person in ipairs(self.actors) do
    if person.is_player then
        person:damage(100)
    end
end
