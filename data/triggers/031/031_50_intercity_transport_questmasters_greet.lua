-- Trigger: Intercity transport questmasters greet
-- Zone: 31, ID: 50
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #3150

-- Converted from DG Script #3150: Intercity transport questmasters greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- This is a greet trigger for the transportation assistants who
-- move newbies between cities.
-- switch on self.id
if self.id == 30075 or self.id == 3151 then
    local myname = "barbarian"
elseif self.id == 3152 then
    local myname = "dwarf"
elseif self.id == 30074 then
    local myname = "drow"
elseif self.id == 30076 then
    local myname = "human"
elseif self.id == 30077 then
    local myname = "orc"
elseif self.id == 3150 then
else
    local myname = "elf"
end
if actor.level < 16 and actor.id == -1 and actor:get_quest_stage("intercity_transport") == 0 then
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'Would you like a trip to a faraway city?'</>")
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'If so, just ask me <b:white>Yes</><blue> and I'll tell you all about it.'</>")
end