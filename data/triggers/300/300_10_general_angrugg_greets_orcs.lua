-- Trigger: General Angrugg greets orcs
-- Zone: 300, ID: 10
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #30010

-- Converted from DG Script #30010: General Angrugg greets orcs
-- Original: MOB trigger, flags: GREET, probability: 70%

-- 70% chance to trigger
if not percent_chance(70) then
    return true
end
if string.find(actor.race, "orc") then
    wait(2)
    self.room:send_except(actor, tostring(self.alias) .. " looks at " .. tostring(actor.alias) .. ".")
    actor:send(tostring(self.alias) .. " looks at you.")
    wait(1)
    self:say("Hrm, perhaps you can help me.")
    self:say("I need to know what those treacherous paladins are up to.")
    wait(3)
    self:say("Bring me some of their messages, if you find any, and I will reward you.")
end