-- Trigger: Intercity transport questmasters greet
-- Zone: 30, ID: 150
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #3150

-- Converted from DG Script #3150: Intercity transport questmasters greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- This is a greet trigger for the transportation assistants who
-- move newbies between cities.
-- switch on self.id
local myname = "elf"
if self.id == 30075 or self.id == 3151 then
    myname = "barbarian"
elseif self.id == 3152 then
    myname = "dwarf"
elseif self.id == 30074 then
    myname = "drow"
elseif self.id == 30076 then
    myname = "human"
elseif self.id == 30077 then
    myname = "orc"
elseif self.id == 3150 then
    -- legacy: questmaster 3150 had no myname; bail before sending speech
    return true
end
if actor.level < 16 and actor.is_player and actor:get_quest_stage("intercity_transport") == 0 then
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'Would you like a trip to a faraway city?'</>")
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'If so, just ask me <b:white>Yes</><blue> and I'll tell you all about it.'</>")
end