-- Trigger: nexus_clock_pin_reload
-- Zone: 12, ID: 3
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1203

-- Converted from DG Script #1203: nexus_clock_pin_reload
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: Rock well demon
if not (cmd == "Rock" or cmd == "well" or cmd == "demon") then
    return true  -- Not our command
end
self.room:spawn_object(12, 3)
self.room:send("The &9<blue>Nexus</> <red>Cloak</> &9<blue>Pin</> beings to <b:blue>gl<b:cyan>ow</> mysteriously then fades back to normal.")
world.destroy(self)