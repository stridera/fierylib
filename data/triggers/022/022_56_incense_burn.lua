-- Trigger: Incense_Burn
-- Zone: 22, ID: 56
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2256

-- Converted from DG Script #2256: Incense_Burn
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: burn
if not (cmd == "burn") then
    return true  -- Not our command
end
actor:send("The old <b:cyan>i<b:yellow>n<b:cyan>c<b:yellow>e<b:cyan>n<b:yellow>s<b:cyan>e</> lights briefly and begins to emit a <b:magenta>noxious</> odor.")
self.room:send_except(actor, tostring(actor.name) .. " lights the old <b:cyan>i<b:yellow>n<b:cyan>c<b:yellow>e<b:cyan>n<b:yellow>s<b:cyan>e</> and it begins to emit a <b:magenta>noxious</> odor.")
wait(5)
self.room:send("The old <b:cyan>i<b:yellow>n<b:cyan>c<b:yellow>e<b:cyan>n<b:yellow>s<b:cyan>e</> starts to flash brightly, sending sparks everywhere!")
wait(5)
self.room:send("The <b:white>sparks</> spray all over the ground in some oddly apparent <b:yellow>pattern</>.")
wait(5)
self.room:send("As the <b:white>smoke</> clears, a message is revealed in the <b:red>scorched</> ground...")
wait(5)
self.room:send("Held by an <b:green>old hag</> who sits above her <b:white>cauldron</> brewing evil potions.")
self.room:send("Though <b:cyan>formidable</>, you must first pass the <b:yellow>door</> that is without a knot.")