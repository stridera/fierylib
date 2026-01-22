-- Trigger: Dandelion_Blow
-- Zone: 22, ID: 51
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2251

-- Converted from DG Script #2251: Dandelion_Blow
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: blow
if not (cmd == "blow") then
    return true  -- Not our command
end
actor:send("You <b:white>blow</> the seeds from the small <b:cyan>dandelion</> in all directions.")
self.room:send_except(actor, tostring(actor.name) .. " <b:white>blows</> on the small <b:cyan>dandelion</>, sending seeds everywhere.")
wait(5)
self.room:send("A <b:cyan>breeze</> picks up, swirling the <b:yellow>seeds</> about and whispering in you ear...")
wait(5)
self.room:send("Resting in the <b:blue>frigid</> pools, this 75' long lizard keeps a <b:red>demented</> grin.")
self.room:send("Though aged, her vicious <b:red>roar</> is more menacing than the greatest of <b:yellow>lions</>.")