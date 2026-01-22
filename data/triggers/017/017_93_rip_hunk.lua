-- Trigger: Rip Hunk
-- Zone: 17, ID: 93
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #1793

-- Converted from DG Script #1793: Rip Hunk
-- Original: OBJECT trigger, flags: GET, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
actor:send("With a ferocious roar the " .. tostring(self) .. " rips out a hunk of your flesh!")
self.room:send_except(actor, "With a ferocious roar the " .. tostring(self) .. " rips a hunk of flesh from " .. tostring(actor.name) .. "!")
actor:damage(700)  -- type: physical