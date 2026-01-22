-- Trigger: Fiery wisp tries to get attention
-- Zone: 615, ID: 10
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61510

-- Converted from DG Script #61510: Fiery wisp tries to get attention
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
if self.room == 61538 then
    get_room(615, 37):at(function()
        self.room:send("You notice a bright, moving light just to the north - too bright to be a firefly.")
    end)
end