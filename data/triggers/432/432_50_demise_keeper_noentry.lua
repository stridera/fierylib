-- Trigger: Demise_Keeper_NoEntry
-- Zone: 432, ID: 50
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #43250

-- Converted from DG Script #43250: Demise_Keeper_NoEntry
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: north
if not (cmd == "north") then
    return true  -- Not our command
end
actor:send(tostring(self.name) .. " steps in your way.")
self.room:send_except(actor, tostring(actor.name) .. " moves toward the door, but " .. tostring(self.name) .. " steps in " .. tostring(actor.possessive) .. " way.")
actor:send(tostring(self.name) .. " eyes you warily.")
self.room:send_except(actor, tostring(self.name) .. " eyes " .. tostring(actor.name) .. " warily.")
self:say("None shall pass but those of our order.")
self:say("Turn back, traveller...live your days well.")