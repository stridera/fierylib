-- Trigger: Shadow Doom 2
-- Zone: 0, ID: 9
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #9

-- Converted from DG Script #9: Shadow Doom 2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 9036 then
    wait(5)
    actor:send("The </>&9<blue>Shadow Doom</> guard grins wickedly, and escourts you from the hall.</>")
    actor:teleport(get_room(91, 20))
    self.room:send_except(actor, tostring(actor.name) .. " is thrown out from the </>&9<blue>Shadow Doom</> hall.</>")
else
    wait(5)
    self:say("What the hell is this?!")
    self:command("drop " .. tostring(object.name))
    _return_value = false
end
return _return_value