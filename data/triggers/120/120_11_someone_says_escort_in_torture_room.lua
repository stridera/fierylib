-- Trigger: Someone says 'escort' in torture room
-- Zone: 120, ID: 11
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12011

-- Converted from DG Script #12011: Someone says 'escort' in torture room
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
local brownie = self.room:find_actor("haggard-brownie")
local tormentor = self.room:find_actor("dark-pixie-tormentor")
if brownie and not tormentor then
    brownie:command("nod " .. actor.name)
    brownie:say("Please take me back to the light forest!")
    wait(0.8)
    brownie:follow(actor)
elseif brownie and tormentor then
    tormentor:command("snicker")
    wait(2)
    tormentor:say("Stay out of this, grain-eater.")
end
return true