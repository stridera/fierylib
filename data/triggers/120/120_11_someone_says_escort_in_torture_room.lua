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
if not (string.find(string.lower(speech), "escort")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
_return_value = false
if (self:get_people("12019")) and not (self:get_people("12020")) then
    self.room:find_actor("haggard-brownie"):command("nod " .. tostring(actor.name))
    self.room:find_actor("haggard-brownie"):say("Please take me back to the light forest!")
    wait(8)
    self.room:find_actor("haggard-brownie"):follow(actor.name)
elseif (self:get_people("12019")) and (self:get_people("12020")) then
    self.room:find_actor("dark-pixie-tormentor"):command("snicker")
    wait(2)
    self.room:find_actor("dark-pixie-tormentor"):say("Stay out of this, grain-eater.")
end
return _return_value