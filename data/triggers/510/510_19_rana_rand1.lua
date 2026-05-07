-- Trigger: rana_rand1
-- Zone: 510, ID: 19
-- Type: MOB, Flags: RANDOM
--
-- Original DG Script: #51019
-- 20% per random tick: Rana sighs and second-guesses ignoring
-- Shema's warnings.

if not percent_chance(20) then
    return true
end
self:command("sigh")
self:say("I should have known it was all too good to be true.  I should have listened to Shema.")
self:command("whap me")