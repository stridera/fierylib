-- Trigger: sysmaith
-- Zone: 22, ID: 74
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #2274

-- Converted from DG Script #2274: sysmaith
-- Original: OBJECT trigger, flags: WEAR, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
wait(2)
actor:send("As you wield " .. tostring(self.shortdesc) .. ", a <b:blue>bright blue</> flame burns along the blade!")
self.room:send_except(actor, "As " .. tostring(actor.name) .. " wields " .. tostring(self.shortdesc) .. ", a <b:blue>bright blue</> flame burns along the blade!")