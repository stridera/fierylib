-- Trigger: Smugg_chief_greet1
-- Zone: 363, ID: 6
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #36306

-- Converted from DG Script #36306: Smugg_chief_greet1
-- Original: MOB trigger, flags: GREET, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
actor:send("The chief guard frisks you quickly and expertly for donuts.")  -- typo: sent
self.room:send_except(actor, "The chief guard frisks " .. tostring(actor.name) .. " quickly and expertly for donuts.")
self:command("grumble")
self:say("Someone's stealing them...")
self:command("fume")