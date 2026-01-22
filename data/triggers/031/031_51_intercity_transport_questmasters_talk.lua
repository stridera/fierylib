-- Trigger: Intercity transport questmasters talk
-- Zone: 31, ID: 51
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3151

-- Converted from DG Script #3151: Intercity transport questmasters talk
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
if actor:get_quest_stage("intercity_transport") == 0 then
    actor.name:start_quest("intercity_transport")
end
-- switch on self.id
if self.id == 3151 or self.id == 30075 then
    local myname = "barbarian"
    local dest = "Ickle"
elseif self.id == 3152 then
    local myname = "dwarf"
    local dest = "Anduin"
elseif self.id == 30074 then
    local myname = "drow"
    local dest = "Anduin"
elseif self.id == 30076 then
    local myname = "human"
    local dest = "Mielikki"
elseif self.id == 30077 then
    local myname = "orc"
    local dest = "Ogakh"
elseif self.id == 3150 then
else
    local myname = "elf"
    local dest = "Mielikki"
end
wait(3)
if actor.level < 16 then
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'As long as you're under level 16, I can transport you to " .. tostring(dest) .. ".'</>")
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'Just ask me 'transport', and I'll send you.'</>")
else
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'I send people below level 16 to " .. tostring(dest) .. ".'</>")
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'Unfortunately, you are too powerful.'</>")
end