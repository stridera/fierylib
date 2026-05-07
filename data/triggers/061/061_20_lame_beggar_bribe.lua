-- Trigger: lame_beggar_bribe
-- Zone: 61, ID: 20
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #6120

-- Converted from DG Script #6120: lame_beggar_bribe
-- Original: MOB trigger, flags: BRIBE, probability: 1%

-- TODO(corpus-wide): converter mistranslated DG bribe-narg as a percent chance.
-- Original `0 m 1` means "fire when bribed with >= 1 copper". The check below
-- now reads it as a 1% probability, which silently breaks the trigger 99% of
-- the time. Fix should be `if (amount or 0) < 1 then return true end` once a
-- corpus-wide convention is settled (see also 030_166, 030_171, 030_183, etc.).
if not percent_chance(1) then
    return true
end
wait(1)
self.room:send(tostring(self.name) .. "'s eyes light up.")
if actor.gender == "Female" then
    self:say("Thank you so much, madam!")
else
    self:say("Thank you so much, sir!")
end