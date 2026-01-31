-- Trigger: swamp-exit-yugoloth
-- Zone: 22, ID: 8
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2208

-- Converted from DG Script #2208: swamp-exit-yugoloth
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
self.room:send("<green>The swamp drains, leaving a <blue>moss</><green>-covered staircase leading down.</>")
get_room(22, 12):exit("down"):set_state({hidden = false})
get_room(22, 12):exit("down"):set_state({description = "&2A slippery staircase leads down.&0"})