-- Trigger: banshee_shriek_greet
-- Zone: 470, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #47001

-- Converted from DG Script #47001: banshee_shriek_greet
-- Original: MOB trigger, flags: GREET, probability: 80%

-- 80% chance to trigger
if not percent_chance(80) then
    return true
end
if actor.level < 100 then
    wait(4)
    actor:send(tostring(self.name) .. " shrieks in utter <b:yellow>terror</> at your entrance!")
    self.room:send_except(actor, tostring(self.name) .. " shrieks in utter <b:yellow>terror</> as " .. tostring(actor.name) .. " enters!")
end