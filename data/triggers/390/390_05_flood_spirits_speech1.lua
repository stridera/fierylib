-- Trigger: flood_spirits_speech1
-- Zone: 390, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #39005

-- Converted from DG Script #39005: flood_spirits_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help")) then
    return true  -- No matching keywords
end
-- switch on self.id
if self.id == 39013 then
    local color = "&4"
elseif self.id == 39014 then
    local color = "&6"
elseif self.id == 39016 then
    local color = "&2"
elseif self.id == 39018 then
    local color = "&7&b"
elseif self.id == 39020 then
    local color = "&6&b"
elseif self.id == 39019 then
    local color = "&9&b"
elseif self.id == 39015 or self.id == 39017 then
else
    local color = "&4&b"
end
if actor:get_quest_stage("flood") == 1 then
    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Help with what?'</>")
end