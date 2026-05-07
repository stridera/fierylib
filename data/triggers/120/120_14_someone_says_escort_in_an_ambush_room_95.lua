-- Trigger: Someone says 'escort' in an ambush room 95
-- Zone: 120, ID: 14
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12014

-- Converted from DG Script #12014: Someone says 'escort' in an ambush room 95
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: escort
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "escort") then
    return true  -- No matching keywords
end
wait(4)
local brownie = self.room:find_actor("haggard-brownie")
local male = self.room:find_actor("dark-pixie-ambusher-male")
local female = self.room:find_actor("dark-pixie-ambusher-female")
if brownie and not male and not female then
    brownie:command("nod " .. actor.name)
    brownie:say("Please take me back to the light forest!")
    wait(8)
    brownie:follow(actor)
elseif brownie and (male or female) then
    brownie:emote("glances fearfully at a dark pixie.")
end
return true