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
doors.set_state(get_room(492, 19), "down", {action = "room"})
wait(15)
doors.set_state(get_room(492, 19), "down", {action = "purge"})