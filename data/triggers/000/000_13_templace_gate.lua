-- Trigger: Templace Gate
-- Zone: 0, ID: 13
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #13

-- Converted from DG Script #13: Templace Gate
-- Original: MOB trigger, flags: GREET, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
if actor.level >= 80 then
    actor:send(self.name .. " tells you, 'Hi " .. actor.name .. ", Welcome to city of Templace!'")
    self.room:send_except(actor, self.name .. " welcomes " .. actor.name)
elseif actor.level <= 79 then
    actor:send(self.name .. " tells you, 'Hey, this is too dangerous a place for you!'")
    self.room:send_except(actor, self.name .. " looks at " .. actor.name .. " doubtfully and makes a strange gesture.")
    actor:teleport(get_room(30, 1))
    if actor:is_immortal() then
        actor:send(self.name .. " falls to the ground and starts worshiping you!")
        self.room:send_except(actor, self.name .. " falls to the ground in total awe of " .. actor.name .. "'s power.")
    end
end