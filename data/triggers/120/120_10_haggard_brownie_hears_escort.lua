-- Trigger: Haggard brownie hears 'escort'
-- Zone: 120, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12010

-- Converted from DG Script #12010: Haggard brownie hears 'escort'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: escort
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "escort")) then
    return true  -- No matching keywords
end
local rescuer = actor.name
globals.rescuer = globals.rescuer or true
if self.room ~= 12103 and self.room ~= 12095 and self.room ~= 12030 then
    wait(4)
    self:follow(actor.name)
end