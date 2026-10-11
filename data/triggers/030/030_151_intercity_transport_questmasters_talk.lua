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
if (self.zone_id == 30 and self.id == 151) or (self.zone_id == 300 and self.id == 75) then
    myname = "barbarian"
    dest = "Ickle"
elseif (self.zone_id == 30 and self.id == 152) then
    myname = "dwarf"
    dest = "Anduin"
elseif (self.zone_id == 300 and self.id == 74) then
    myname = "drow"
    dest = "Anduin"
elseif (self.zone_id == 300 and self.id == 76) then
    myname = "human"
    dest = "Mielikki"
elseif (self.zone_id == 300 and self.id == 77) then
    myname = "orc"
    dest = "Ogakh"
elseif (self.zone_id == 30 and self.id == 150) then
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