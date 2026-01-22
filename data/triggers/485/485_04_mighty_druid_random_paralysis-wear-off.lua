-- Trigger: mighty druid random paralysis-wear-off
-- Zone: 485, ID: 4
-- Type: MOB, Flags: RANDOM
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #48504

-- Converted from DG Script #48504: mighty druid random paralysis-wear-off
-- Original: MOB trigger, flags: RANDOM, probability: 100%
local now = time.stamp
if paralysis_victim_1 and ((paralysis_victim_1.room ~= self.room) or (paralysis_expire_1 <= now)) then
    if paralysis_victim_1.room == self.room then
        self.room:send_except(paralysis_victim_1, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
        paralysis_victim_1:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
    end
    paralysis_victim_1 = nil
end
if paralysis_victim_2 and ((paralysis_victim_2.room ~= self.room) or (paralysis_expire_2 <= now)) then
    if paralysis_victim_2.room == self.room then
        self.room:send_except(paralysis_victim_2, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
        paralysis_victim_2:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
    end
    paralysis_victim_2 = nil
end
if paralysis_victim_3 and ((paralysis_victim_3.room ~= self.room) or (paralysis_expire_3 <= now)) then
    if paralysis_victim_3.room == self.room then
        self.room:send_except(paralysis_victim_3, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
        paralysis_victim_3:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
    end
    paralysis_victim_3 = nil
end
if paralysis_victim_4 and ((paralysis_victim_4.room ~= self.room) or (paralysis_expire_4 <= now)) then
    if paralysis_victim_4.room == self.room then
        self.room:send_except(paralysis_victim_4, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
        paralysis_victim_4:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
    end
    paralysis_victim_4 = nil
end