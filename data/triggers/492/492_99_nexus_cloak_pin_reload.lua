-- Trigger: nexus_cloak_pin_reload
-- Zone: 492, ID: 99
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #49299

-- Converted from DG Script #49299: nexus_cloak_pin_reload
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: rock well demon
if not (cmd == "rock" or cmd == "well" or cmd == "demon") then
    return true  -- Not our command
end
self.room:spawn_object(492, 99)
self.room:send("The &9<blue>Nexus <red>Cloak</> &9<blue>Pin</> begins to <b:blue>gl<b:cyan>ow</> mysteriously then fades back to normal.")
actor:command("get pin")
world.destroy(self)