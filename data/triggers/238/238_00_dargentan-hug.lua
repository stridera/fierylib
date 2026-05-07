-- Trigger: dargentan-hug
-- Zone: 238, ID: 0
-- Type: MOB, Flags: COMMAND
--
-- Dargentan responds to "hug" based on the actor's alignment: good-aligned
-- players get a friendly grin and a hug back, evil-aligned players get growled at.

-- Command filter: hug
if not (cmd == "hug") then
    return true  -- Not our command
end
if actor.alignment > -350 then
    actor:send("The large dragon grins at you, displaying his teeth.")
    self.room:send_except(actor, tostring(self.name) .. " grins toothily at " .. tostring(actor.name) .. ".")
    self:command("hug " .. tostring(actor.name))
else
    self:command("growl " .. tostring(actor.name))
end
