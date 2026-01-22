-- Trigger: Room lets spider create east-blocking webs
-- Zone: 615, ID: 17
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #61517

-- Converted from DG Script #61517: Room lets spider create east-blocking webs
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
if web_present ~= 1 and web_pause ~= 1 then
    local web_present = 1
    globals.web_present = globals.web_present or true
    self.room:find_actor("potbellied-orb-spider"):emote("carefully tosses a leader thread across the path.")
    wait(4)
    self.room:find_actor("potbellied-orb-spider"):emote("crosses the path several more times, then spins the rest of its web.")
    doors.set_flags(get_room(615, 49), "east", "bcd")
    doors.set_description(get_room(615, 49), "east", "A delicate-looking web stretches between two trees, blocking the path.")
    self.room:spawn_object(615, 9)
end