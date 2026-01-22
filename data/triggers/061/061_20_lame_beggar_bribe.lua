-- Trigger: lame_beggar_bribe
-- Zone: 61, ID: 20
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #6120

-- Converted from DG Script #6120: lame_beggar_bribe
-- Original: MOB trigger, flags: BRIBE, probability: 1%

-- 1% chance to trigger
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