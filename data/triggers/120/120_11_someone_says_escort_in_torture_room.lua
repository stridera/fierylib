-- Trigger: Someone says 'escort' in torture room
-- Zone: 120, ID: 11
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12011

-- Converted from DG Script #12011: Someone says 'escort' in torture room
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: escort
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "escort") then
    return true  -- No matching keywords
end
local brownie = self.room:find_actor("haggard-brownie")
local tormentor = self.room:find_actor("dark-pixie-tormentor")
if brownie and not tormentor then
    brownie:command("nod " .. actor.name)
    brownie:say("Please take me back to the light forest!")
    wait(8)
    brownie:follow(actor)
elseif brownie and tormentor then
    tormentor:command("snicker")
    wait(2)
    tormentor:say("Stay out of this, grain-eater.")
end
return true