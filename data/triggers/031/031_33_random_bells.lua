-- Trigger: Random Bells
-- Zone: 31, ID: 33
-- Type: OBJECT, Flags: RANDOM, GET, WEAR, REMOVE
-- Status: CLEAN
--
-- Original DG Script: #3133

-- Converted from DG Script #3133: Random Bells
-- Original: OBJECT trigger, flags: RANDOM, GET, WEAR, REMOVE, probability: 100%
if actor then
    -- this is a wear trigger
    local myowner = actor
    globals.myowner = globals.myowner or true
    self.room:send_except(myowner, "Bells ring on " .. tostring(myowner.name) .. "'s hat as " .. tostring(myowner.name) .. " moves.")
    myowner:send("The bells on your hat ring as you shift your position.")
else
    -- this is a random trigger
    if myowner then
        if myowner:has_equipped("3306") then
            -- the global variable was set (by the wear trigger)
            self.room:send_except(myowner, "Bells ring on " .. tostring(myowner.name) .. "'s hat as " .. tostring(myowner.name) .. " moves.")
            myowner:send("The bells on your hat ring as you shift your position.")
        else
            -- hat not worn, so assume it was removed
            myowner = nil
        end
    end
end