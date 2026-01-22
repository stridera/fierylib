-- Trigger: seagulls, stop it now
-- Zone: 625, ID: 74
-- Type: OBJECT, Flags: DEFEND
-- Status: CLEAN
--
-- Original DG Script: #62574

-- Converted from DG Script #62574: seagulls, stop it now
-- Original: OBJECT trigger, flags: DEFEND, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
if count > 0 then
    self.room:send("Count: " .. tostring(count))
    if worn_on ~= 0 then
        victim:say("Stop it, " .. tostring(actor.name) .. "!")
        spells.cast(self, "minor paralysis", actor, self.level)
        local add = damage / 100
        self.room:send("First Add: " .. tostring(add))
        local add = add + 1
        self.room:send("Second Add: " .. tostring(add))
        local count = count + add
        self.room:send("count: " .. tostring(count))
        wait(count)
    end
    self.room:send("count is over")
    return _return_value
else
    local count = 1
    globals.count = globals.count or true
end