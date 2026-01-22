-- Trigger: dragonsaddle_melt
-- Zone: 188, ID: 92
-- Type: OBJECT, Flags: GET, WEAR
-- Status: CLEAN
--
-- Original DG Script: #18892

-- Converted from DG Script #18892: dragonsaddle_melt
-- Original: OBJECT trigger, flags: GET, WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if (actor.id == 18890) or (actor.id == 18891) then
else
    _return_value = false
    if actor.canbeseen then
        actor:send("As you take hold of " .. tostring(self.shortdesc) .. ", it melts between your fingers.")
        self.room:send_except(actor, "As " .. tostring(actor.name) .. " takes hold of " .. tostring(self.shortdesc) .. ", it melts between " .. tostring(actor.possessive) .. " fingers.")
    else
        self.room:send(tostring(self.shortdesc) .. " spontaneously combusts.")
    end
    world.destroy(self)
end
return _return_value