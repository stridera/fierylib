-- Trigger: give things to the wrong officer
-- Zone: 300, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #30008

-- Converted from DG Script #30008: give things to the wrong officer
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == 30212 or object.id == 30208 then
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " tries to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You try to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ", but " .. tostring(self.name) .. " refuses.")
    wait(1)
    self:say("Eh?  Don't bother me with this stuff.")
    self:say("Give it to the general, he does all the planning around here.")
else
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " tries to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You try to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ", but " .. tostring(self.name) .. " refuses.")
    wait(1)
    self:say("What?  Don't bother me with such trifles!")
end
return _return_value