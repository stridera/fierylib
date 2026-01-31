-- Trigger: Ranger makes path to maddened diplomat
-- Zone: 502, ID: 6
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #50206

-- Converted from DG Script #50206: Ranger makes path to maddened diplomat
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
get_room(502, 16):exit("south"):set_state({hidden = false})
get_room(502, 16):exit("south"):set_state({description = "A faint path leads through the thicket."})
wait(2)
self.room:send("The quiet ranger points out a hidden trail heading south.")
wait(20)
self.room:send("A gentle breeze disturbs the branches, and the path is no longer visible.")
get_room(502, 16):exit("south"):set_state({hidden = true})