-- Trigger: Arre Matu refuse
-- Zone: 51, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5104

-- Converted from DG Script #5104: Arre Matu refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
--
-- Arre Matu refuses any object the player tries to give her that doesn't
-- match a more specific receive trigger (the sash receive lives in 51/12).
-- Note: legacy DG header listed probability 0%, but receive triggers in
-- DG fired on every receive event regardless of header probability -- the
-- converter's percent_chance(0) gate has been removed.
self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
wait(1)
self:command("eye " .. actor.name)
actor:send(self.name .. " says, 'What is this? I have no need for " .. object.shortdesc .. ".'")
return true