-- Trigger: karla_chichi
-- Zone: 43, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4309

-- Converted from DG Script #4309: karla_chichi
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: Don't you think so?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "don't") or string.find(string.lower(speech), "you") or string.find(string.lower(speech), "think") or string.find(string.lower(speech), "so?")) then
    return true  -- No matching keywords
end
local room = self.room
if %room.people[4301] ~= 0 then
    self:emote("gets up in a player's face.")
    self:say("Oh no you di'in' Chichi!")
    wait(5)
    self:say("You best step off!")
    self:emote("struts around the room, waiving her finger.")
end