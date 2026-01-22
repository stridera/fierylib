-- Trigger: Herlequin vial trigger
-- Zone: 63, ID: 90
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6390

-- Converted from DG Script #6390: Herlequin vial trigger
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: pour vial volcano
if not (cmd == "pour" or cmd == "vial" or cmd == "volcano") then
    return true  -- Not our command
end
wait(5)
actor:send("Metamorpho's vial is ripped from your hands!")
self.room:send_except(actor, "Metamorpho's vial is ripped from " .. tostring(actor.name) .. "'s hands!")
wait(6)
self.room:send("Metamorpho's vial hovers above the massive volcano before turning upside down!")
wait(2)
self.room:send("The top of the vial pops open unleashing a <b:cyan>FLOOD</> of water!")
wait(2)
self.room:send("The massive volcano slowly burns itself out with a puff of smoke!")
world.destroy(self.room:find_object("volcano"))
self.room:spawn_object(1000, 75)
self.room:spawn_object(1000, 75)
self.room:spawn_object(1000, 75)
self.room:spawn_object(1000, 75)
world.destroy(self)