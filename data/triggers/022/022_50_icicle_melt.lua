-- Trigger: Icicle_Melt
-- Zone: 22, ID: 50
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2250

-- Converted from DG Script #2250: Icicle_Melt
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: melt
if not (cmd == "melt") then
    return true  -- Not our command
end
actor:send("The long <b:blue>icicle</> starts to soften up and begins to melt.")
self.room:send_except(actor, tostring(actor.name) .. " squeezes the <b:blue>icicle</> and it begins to melt.")
wait(5)
self.room:send("<yellow></>Gratz on finding the 1st piece!  This <b:red>IS<white></> the format for whole the quest.</>")
wait(3)
self.room:send("The water <cyan></>droplets</> flow from the <blue></>icicle</> to the ground, forming a <b:white>puddle</>.")
wait(5)
self.room:send("Suddenly, <b:yellow>words</> begin to slowly take form in the <b:white>puddle</>.")
wait(2)
self.room:send("Held by a peaceful man oft found meditating in his favorite sacred grove.")
self.room:send("A difficult opponent if tested, his wand wisks anything away with a few taps.")