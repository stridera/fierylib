-- Trigger: give things to the wrong officer
-- Zone: 300, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #30008

-- Converted from DG Script #30008: give things to the wrong officer
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Subordinate officer redirects message-bearing items (302:12 spy scroll,
-- 302:8 paladin parchment) to the general; refuses everything else outright.
self.room:send_except(actor, tostring(actor.name) .. " tries to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You try to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ", but " .. tostring(self.name) .. " refuses.")
wait(1)
if object.zone_id == 302 and (object.local_id == 12 or object.local_id == 8) then
    self:say("Eh?  Don't bother me with this stuff.")
    self:say("Give it to the general, he does all the planning around here.")
else
    self:say("What?  Don't bother me with such trifles!")
end
return true