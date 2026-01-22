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
if level ($n) >= 80 then
    self.room:send("$n $I tells you, 'Hi $n, Welcome to city of Templace!'")  -- from MPROG
    self.room:send_except(actor, "self.name welcomes actor.name")  -- from MPROG
end
if level ($n) <= 79 then
    actor:send("self.name tells you, 'Hey, this is too dangerous a place for you!'")  -- from MPROG
    self.room:send_except(actor, "self.name looks at actor.name doubtfully and makes a strange gesture.")  -- from MPROG
    actor:teleport(get_room(30, 1))  -- from MPROG
    if isimmort ($n) then
        self.room:send("$n $I falls to the ground and starts worshiping you!")  -- from MPROG
        self.room:send_except(actor, "self.name falls to the ground in total awe of actor.name's power.")  -- from MPROG
    end
end  -- auto-close block