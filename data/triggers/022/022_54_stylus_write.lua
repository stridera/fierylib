-- Trigger: Stylus_Write
-- Zone: 22, ID: 54
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2254

-- Converted from DG Script #2254: Stylus_Write
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: write
if not (cmd == "write") then
    return true  -- Not our command
end
actor:send("The <b:yellow>c<b:green>o<b:blue>l<b:magenta>o<b:yellow>r<b:cyan>f<b:magenta>u<b:red>l</> stylus glows briefly, filling the room with light.")
self.room:send_except(actor, tostring(actor.name) .. " writes with a <b:yellow>c<b:green>o<b:blue>l<b:magenta>o<b:yellow>r<b:cyan>f<b:magenta>u<b:red>l</> stylus and it begins to glow brightly.")
wait(5)
actor:send("The <b:yellow>c<b:green>o<b:blue>l<b:magenta>o<b:yellow>r<b:cyan>f<b:magenta>u<b:red>l</> stylus flies from your hands and begins writing in the air.")
self.room:send_except(actor, "The <b:yellow>c<b:green>o<b:blue>l<b:magenta>o<b:yellow>r<b:cyan>f<b:magenta>u<b:red>l</> stylus suddenly begins writing in the air by itself.")
wait(3)
self.room:send("Held by a hidden man, he was the only one to achieve <b:white>immortality</> via <b:blue>wizardry</>.")
self.room:send("Though <b:blue>magic</> slowed his age, endlessly he searchs for a new <b:white>soul</> to <b:red>leach</>.")