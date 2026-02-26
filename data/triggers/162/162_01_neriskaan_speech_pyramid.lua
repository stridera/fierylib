-- Trigger: neriskaan speech pyramid
-- Zone: 162, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16201

-- Converted from DG Script #16201: neriskaan speech pyramid
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: neris'kaan Neris'Kaan
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "neris'kaan") or string.find(string.lower(speech), "neris'kaan")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
doors.set_state(get_room(162, 71), "n", {action = "room"})
self.room:send("<b:yellow>Dust fills the air as a wind groans by you flowing to the north.</>")
self.room:send("<yellow>Massive pillars of stone open to form a new passage.</>")
_return_value = false
return _return_value