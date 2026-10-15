-- Trigger: mighty druid random paralysis-wear-off
-- Zone: 484, ID: 104
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48504
--
-- Releases entangled players whose slot expired or who left the room. The slots are the DG
-- globals `paralysis_victim_N` / `paralysis_expire_N` written by 484_105 (this mob's `globals`).

local now = timestamp()  -- game hours, as legacy %time.stamp%
for n = 1, 4 do
    local v = globals["paralysis_victim_" .. n]
    if v and (v.room ~= self.room or (globals["paralysis_expire_" .. n] or 0) <= now) then
        if v.room == self.room then
            self.room:send_except(v, "<green>The crop of roots recedes, releasing " .. tostring(v.name) .. " from its grasp.</>")
            v:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
        else
            self.room:send("<green>The crop of roots recedes, releasing " .. tostring(v.name) .. " from its grasp.</>")
        end
        globals["paralysis_victim_" .. n] = nil
    end
end
