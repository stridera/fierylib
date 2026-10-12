-- Trigger: Kerristone (Royal Stables)
-- Zone: 0, ID: 11
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
-- Num arg: 25
--
-- Original DG Script: #11

-- Converted from DG Script #11: Kerristone (Royal Stables)
-- Original: MOB trigger, flags: BRIBE, num_arg: 25 (minimum bribe in copper)

-- DG BRIBE num_arg 25: fires only when the coins are worth at least 25 copper.
if (value or 0) < 25 then
    return true
end
self.room:send("</><b:yellow>Licub</> nods to " .. tostring(actor.name) .. " and goes to fetch a horse.")
wait(5)
self.room:send("</><b:yellow>Licub</> returns with a </><yellow>well-bred warhorse</>.")