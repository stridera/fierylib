-- Trigger: arena-exits
-- Zone: 22, ID: 25
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2225

-- Converted from DG Script #2225: arena-exits
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
self.room:send("&9<blue>A gate opens on the floor of the arena, leading down into darkness.</>")
get_room(22, 16):exit("down"):set_state({hidden = false})
get_room(22, 16):exit("down"):set_state({description = "&9&bA grate has opened, leading down...&0"})