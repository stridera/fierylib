-- Trigger: Mausoleum 2
-- Zone: 0, ID: 86
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #86

-- Converted from DG Script #86: Mausoleum 2
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: path
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "path")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
get_room(85, 25):exit("d"):set_state({hidden = false})
self.room:send("The Blood of the Evil Runes begins to boil, and solidifies into a trapdoor.")
_return_value = false
return _return_value