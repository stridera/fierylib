-- Trigger: Match_Light
-- Zone: 22, ID: 60
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2260

-- Converted from DG Script #2260: Match_Light
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: light
if not (cmd == "light") then
    return true  -- Not our command
end
actor:send("You strike the <b:red>match</> on the ground as <b:white>bright sparks</> shoot forth.")
self.room:send_except(actor, tostring(actor.name) .. " strikes the <b:red>match</> on the ground as <b:white>bright sparks</> shoot forth.")
wait(7)
self.room:send("The <b:red>match</> suddenly flares into a briliant blinding <b:yellow>explosion</> of <b:white>light</>.")
wait(5)
self.room:send("As your eyes adjust, you recall a <cyan>faint</> image <b:red>burned</> in your <b:blue>mind</>...")
wait(5)
self.room:send("The <yellow>crumbled</> remains of a once <b:white>great city</> and endless billowing <b:cyan>ash</>.")
self.room:send("A strong <b:green>oaf</>, and would be <b:white>nobler</> if it weren't for his <b:red>evil passion</>.")