-- Trigger: Exit_switch
-- Zone: 492, ID: 2
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #49202

-- Converted from DG Script #49202: Exit_switch
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(1)
self.room:send_except(actor, "The winds shift violently ripping up the sands and ground, leaving the way unknown.")
get_room(492, 19):exit("down"):set_state({hidden = false})
wait(15)
get_room(492, 19):exit("down"):set_state({hidden = true})