-- Trigger: Lamp_Rub
-- Zone: 22, ID: 55
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2255

-- Converted from DG Script #2255: Lamp_Rub
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: rub
if not (cmd == "rub") then
    return true  -- Not our command
end
actor:send("The <b:yellow>old lamp</> begins to shake as a cloud of <b:white>smoke</> comes out.")
self.room:send_except(actor, tostring(actor.name) .. " rubs the <b:yellow>old lamp</> and a cloud of <b:white>smoke</> comes out.")
wait(5)
self.room:send("The cloud of <b:white>smoke</> begins to thin out and forms into <b:cyan>words</>.")
wait(7)
self.room:send("Held by a <b:cyan>poltergeist</> that is about as far from <b:green>Mielikki</> as possible.")
self.room:send("In his <b:yellow>master's chamber</> he does rest, expelling his energy <b:white>peacefully</> about.")