-- Trigger: muleard_greet
-- Zone: 87, ID: 9
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8709

-- Converted from DG Script #8709: muleard_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    wait(2)
    actor:send(tostring(self.name) .. " turns around and looks at you.")
    wait(1)
    actor.name:send(self.name .. " tells you, '" .. "Welcome to my store." .. "'")
    wait(1)
    actor.name:send(self.name .. " tells you, '" .. "You can call me Mule." .. "'")
end