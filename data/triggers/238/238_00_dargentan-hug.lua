-- Trigger: dargentan-hug
-- Zone: 238, ID: 0
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #23800

-- Converted from DG Script #23800: dargentan-hug
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: hug
if not (cmd == "hug") then
    return true  -- Not our command
end
if actor.alignment > -350 then
    actor.name:send("The large dragon grins at you, displaying his teeth.")
    self.room:send_except(actor, tostring(self.name) .. " grins toothily at " .. tostring(actor.name) .. ".")
    self:command("hug " .. tostring(actor.name))
else
    self:command("growl " .. tostring(actor.name))
end