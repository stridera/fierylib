-- Trigger: Herlequin vial trigger
-- Zone: 63, ID: 90
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6390
-- When a player attempts `pour vial volcano`, ~2% chance to extinguish
-- the volcano (object 63/91) and replace it with four grapesicles
-- (object 1000/75). The vial itself is destroyed.

-- Converted from DG Script #6390: Herlequin vial trigger
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- DG command filter was "pour vial volcano" (matches verb only). We also
-- require the args to mention the volcano so unrelated `pour` commands
-- don't fire this trigger.
if cmd ~= "pour" then
    return true
end
if not (args and string.find(args, "volcano", 1, true)) then
    return true
end

wait(5)
actor:send("Metamorpho's vial is ripped from your hands.")
self.room:send_except(actor, "Metamorpho's vial is ripped from " .. tostring(actor.name) .. "'s hands!")
wait(6)
self.room:send("Metamorpho's vial hovers above the massive volcano before turning upside down.")
wait(2)
self.room:send("The top of the vial pops open unleashing a <b:cyan>FLOOD</> of water!")
wait(2)
self.room:send("The massive volcano slowly burns itself out with a puff of smoke!")
local volcano = self.room:find_object("volcano")
if volcano then
    world.destroy(volcano)
end
-- DG `oload obj 75` references zone 0 → maps to zone 1000 (grapesicle).
self.room:spawn_object(1000, 75)
self.room:spawn_object(1000, 75)
self.room:spawn_object(1000, 75)
self.room:spawn_object(1000, 75)
world.destroy(self)