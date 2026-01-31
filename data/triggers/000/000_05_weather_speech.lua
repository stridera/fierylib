-- Trigger: weather speech
-- Zone: 0, ID: 5
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5

-- Converted from DG Script #5: weather speech
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: weather
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "weather")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
get_room(12, 10):exit("n"):set_state({hidden = false})
self.room:send("<cyan>The air wrinkles and swirls into a door to the north</>")
_return_value = false
return _return_value