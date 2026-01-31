-- Trigger: pit-fiend-room-exit
-- Zone: 22, ID: 6
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2206

-- Converted from DG Script #2206: pit-fiend-room-exit
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
self.room:send("<yellow>The trembling subsides and a <b:red>fi<yellow>er<red>y pit</> <yellow>appears, leading down.</>")
get_room(22, 10):exit("down"):set_state({hidden = false})
get_room(22, 10):exit("down"):set_state({description = "A &1&bburning&0 hole leads down."})