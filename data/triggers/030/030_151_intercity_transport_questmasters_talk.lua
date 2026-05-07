-- Trigger: Intercity transport questmasters talk
-- Zone: 30, ID: 151
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3151

-- Converted from DG Script #3151: Intercity transport questmasters talk
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
if actor:get_quest_stage("intercity_transport") == 0 then
    actor:start_quest("intercity_transport")
end
-- switch on self.id
local myname = "elf"
local dest = "Mielikki"
if self.id == 3151 or self.id == 30075 then
    myname = "barbarian"
    dest = "Ickle"
elseif self.id == 3152 then
    myname = "dwarf"
    dest = "Anduin"
elseif self.id == 30074 then
    myname = "drow"
    dest = "Anduin"
elseif self.id == 30076 then
    myname = "human"
    dest = "Mielikki"
elseif self.id == 30077 then
    myname = "orc"
    dest = "Ogakh"
elseif self.id == 3150 then
    -- legacy: questmaster 3150 had no myname/dest; bail before sending speech
    return true
end
wait(3)
if actor.level < 16 then
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'As long as you're under level 16, I can transport you to " .. tostring(dest) .. ".'</>")
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'Just ask me 'transport', and I'll send you.'</>")
else
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'I send people below level 16 to " .. tostring(dest) .. ".'</>")
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'Unfortunately, you are too powerful.'</>")
end