-- Trigger: Kerristone (Royal Stables)
-- Zone: 0, ID: 11
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #11

-- Converted from DG Script #11: Kerristone (Royal Stables)
-- Original: MOB trigger, flags: BRIBE, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
self.room:send("</><b:yellow>Licub</> nods to " .. tostring(actor.name) .. " and goes to fetch a horse.")
wait(5)
self.room:send("</><b:yellow>Licub</> returns with a </><yellow>well-bred warhorse</>.")