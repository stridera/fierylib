-- Trigger: fv_Briant_greet
-- Zone: 534, ID: 10
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #53410

-- Converted from DG Script #53410: fv_Briant_greet
-- Original: MOB trigger, flags: GREET, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
if actor.id == -1 then
    actor:send(tostring(self.name) .. " tells you, 'Hello Traveler, my name is Briant.'")
    if actor.gender == "male" then
        actor:send("As Briant smiles a welcome to you you feel yourself smiling like a fool!")
    else
        actor:send("As Briant smiles a welcome to you you feel an overwhelming peace.")
    end
else
end