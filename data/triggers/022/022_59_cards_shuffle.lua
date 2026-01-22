-- Trigger: Cards_Shuffle
-- Zone: 22, ID: 59
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2259

-- Converted from DG Script #2259: Cards_Shuffle
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: shuffle
if not (cmd == "shuffle") then
    return true  -- Not our command
end
actor:send("You <b:yellow>shuffle</> the cards around in your hands and a <b:red>Joker</> ends up on top.")
self.room:send_except(actor, tostring(actor.name) .. " <b:yellow>shuffles</> the cards around and a <b:red>Joker</> ends up on top.")
wait(5)
actor:send("You <b:yellow>shuffle</> the cards once more, before cutting to an <b:red>unusual</> card...")
self.room:send_except(actor, tostring(actor.name) .. " <b:yellow>shuffles</> the cards once more, before cutting to an <b:red>unusual</> card...")
wait(5)
self.room:send("The <b:yellow>card</> shows an <b:white>old ship</>, though once a <b:green>prosperous</> merchant vessel.")
self.room:send("As well, a <b:white>resurrected</> man who forever dwells like a good <b:magenta>captain</> should.")