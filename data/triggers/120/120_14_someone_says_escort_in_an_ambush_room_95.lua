-- Trigger: Someone says 'escort' in an ambush room 95
-- Zone: 120, ID: 14
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12014

-- Converted from DG Script #12014: Someone says 'escort' in an ambush room 95
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"escort"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.4)
local brownie = self.room:find_actor("haggard-brownie")
local male = self.room:find_actor("dark-pixie-ambusher-male")
local female = self.room:find_actor("dark-pixie-ambusher-female")
if brownie and not male and not female then
    brownie:command("nod " .. actor.name)
    brownie:say("Please take me back to the light forest!")
    wait(0.8)
    brownie:follow(actor)
elseif brownie and (male or female) then
    brownie:emote("glances fearfully at a dark pixie.")
end
return true