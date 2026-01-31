-- Trigger: Room lets spider create north-blocking web
-- Zone: 615, ID: 33
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #61533

-- Converted from DG Script #61533: Room lets spider create north-blocking web
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
if web_present ~= 1 and web_pause ~= 1 then
    local web_present = 1
    globals.web_present = globals.web_present or true
    self.room:find_actor("orbweaver"):emote("carefully tosses a leader thread across the path.")
    wait(4)
    self.room:find_actor("orbweaver"):emote("crosses the path several more times, then spins the rest of its web.")
    get_room(615, 66):exit("north"):set_state({closed = true, locked = true, pickproof = true})
    get_room(615, 66):exit("north"):set_state({description = "A delicate-looking web stretches between two trees, blocking the path."})
    self.room:spawn_object(615, 11)
end