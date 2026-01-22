-- Trigger: Coin_Flip
-- Zone: 22, ID: 58
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2258

-- Converted from DG Script #2258: Coin_Flip
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: flip
if not (cmd == "flip") then
    return true  -- Not our command
end
self.room:send_except(actor, tostring(actor.name) .. " flips an <b:green>worn coin</>, sending it high in the <b:cyan>air</>.")
actor:send("The <b:yellow>worn</> coin flips high into the air, <b:red>tumbling</> over and over.")
wait(5)
self.room:send("You wait what seems an <b:white>eternity</> as the worn <b:yellow>coin soars</> through the <b:cyan>air</>.")
wait(7)
actor:send("With a <b:green>flick</> of your wrist, you reach out and snag the <b:yellow>worn coin</> in flight.")
self.room:send_except(actor, tostring(actor.name) .. " reaches out and catches the <b:yellow>worn coin</> while on the <b:red>descent</>.")
wait(5)
self.room:send("Where once there were two different <b:green>sides</> there is only a <b:magenta>single</> image...")
wait(3)
self.room:send("Far from <b:green>Mielikki</>, a man of much <b:cyan>jubilation</> and a happy <b:red>lover</>.")
self.room:send("He roams <b:white>peacefully</> about his <b:green>pavillion</> hoping to see his <b:magenta>princess</>.")