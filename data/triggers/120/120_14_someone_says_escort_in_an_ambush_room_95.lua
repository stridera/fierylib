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
if not (string.find(string.lower(speech), "escort")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
_return_value = false
wait(4)
if (self:get_people("12019")) and not (self:get_people("12021")) and not (self:get_people("12022")) then
    self.room:find_actor("haggard-brownie"):command("nod " .. tostring(actor.name))
    self.room:find_actor("haggard-brownie"):say("Please take me back to the light forest!")
    wait(8)
    self.room:find_actor("haggard-brownie"):follow(actor.name)
elseif (self:get_people("12019")) and ((self:get_people("12021")) or (self:get_people("12022"))) then
    self.room:find_actor("haggard-brownie"):emote("glances fearfully at a dark pixie.")
end
return _return_value