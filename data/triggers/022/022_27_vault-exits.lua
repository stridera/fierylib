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
get_room(22, 17):exit("down"):set_state({hidden = false})
get_room(22, 17):exit("down"):set_state({description = "&1&bRed stairs lead &1down to the unknown.&0"})