-- Trigger: necromancer_guild
-- Zone: 169, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #16900

-- Converted from DG Script #16900: necromancer_guild
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- for 16950
if actor.class == "Necromancer" then
    wait(1)
    doors.set_state(get_room(169, 50), "up", {action = "room"})
    self.room:send("The ceiling slides open silently.")
    wait(30)
    doors.set_state(get_room(169, 50), "up", {action = "purge"})
    self.room:send("The ceiling slides closed with a click.")
end