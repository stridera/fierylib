-- Trigger: Mausloeum trigger
-- Zone: 0, ID: 85
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #85

-- Converted from DG Script #85: Mausloeum trigger
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: Ziijhan
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "ziijhan")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
doors.set_state(get_room(85, 24), "w", {action = "room"})
self.room:send("You hear the slow grind of rock against rock. A doorway appears to the west.")
_return_value = false
return _return_value