-- Trigger: vault-exits
-- Zone: 22, ID: 27
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2227

-- Converted from DG Script #2227: vault-exits
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
self.room:send("<b:red>A trapdoor clicks open, </><red>leading down.</>")
doors.set_state(get_room(22, 17), "down", {action = "room"})
doors.set_description(get_room(22, 17), "down", "&1&bRed stairs lead &1down to the unknown.&0")