-- Trigger: fv_poke_Aeron
-- Zone: 534, ID: 14
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #53414

-- Converted from DG Script #53414: fv_poke_Aeron
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: poke
if not (cmd == "poke") then
    return true  -- Not our command
end
if string.find(arg, "aeron") then
    self:command("whap " .. tostring(actor.name))
    self:command("glare " .. tostring(actor.name))
    wait(2)
    self.room:send(tostring(self.name) .. " say, 'Don't interrupt me reading again, unless you have something better")
    self.room:send("</>for me than this book.'")
end