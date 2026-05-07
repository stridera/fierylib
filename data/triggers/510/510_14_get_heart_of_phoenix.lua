-- Trigger: get_heart_of_phoenix
-- Zone: 510, ID: 14
-- Type: OBJECT, Flags: GET
--
-- Original DG Script: #51014
-- The phoenix corpse is too hot to grab bare-handed. The player must
-- be wearing the heat-resistant gloves (510, 26) to claim the heart;
-- success awards 30k XP and latches `already_got` so the bonus is
-- one-shot. Either way, the corpse crumbles to ash on the next tick.
local already_got = already_got or 0
if already_got == 1 then
    return true
end

local allowed
if actor:has_equipped(510, 26) then
    actor:send("The corpse is extremely hot and may combust soon!")
    actor:award_exp(30000)
    globals.already_got = 1
    allowed = true
else
    actor:send("The corpse is too hot to touch without special protection!")
    allowed = false
end

wait(2)
self.room:send("The corpse suddenly crumbles to ash.")
return allowed
