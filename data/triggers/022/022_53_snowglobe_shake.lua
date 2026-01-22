-- Trigger: Snowglobe_Shake
-- Zone: 22, ID: 53
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2253

-- Converted from DG Script #2253: Snowglobe_Shake
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: shake
if not (cmd == "shake") then
    return true  -- Not our command
end
actor:send("The old <b:white>snowglobe</> glows and the small town inside comes <b:cyan>alive</>.")
self.room:send_except(actor, tostring(actor.name) .. " shakes the <b:white>snowglobe</> and the town inside comes <b:cyan>alive</>.")
wait(7)
self.room:send("The <b:magenta>small town</> continues to glow as you make out a visage in the <b:white>snow</>...")
wait(5)
self.room:send("A <b:yellow>tall</> and <yellow>muscular</> <b:white>cleric</> who could almost pass for that of a human.")
self.room:send("His eyes <b:red><b:red>scorch</></> the <b:blue>soul</> of all those who dare gaze deeply into them.")