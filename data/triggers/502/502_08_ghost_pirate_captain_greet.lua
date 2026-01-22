-- Trigger: Ghost Pirate Captain greet
-- Zone: 502, ID: 8
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #50208

-- Converted from DG Script #50208: Ghost Pirate Captain greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(3)
if actor.level < 100 then
    actor:send("<blue>" .. tostring(self.name) .. " tells you, 'Did you take my earring?  What have you</>")
    actor:send("</><blue>done with it, rapscallion!'</>")
end