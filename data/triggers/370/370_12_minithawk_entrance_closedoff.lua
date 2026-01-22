-- Trigger: minithawk_entrance_closedoff
-- Zone: 370, ID: 12
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #37012

-- Converted from DG Script #37012: minithawk_entrance_closedoff
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if direction == "south" then
    self.room:send("Rays of light creep in as the lumber around the mine's entrance is pulled back.")
    wait(1)
    self.room:send("The lumber around the mine's entrance suddenly grows unstable, creaking loudly.")
    self.room:send("In a great cloud of dust the mine entrance collapses, leaving no way back out.")
end