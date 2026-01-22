-- Trigger: exit_room_58196_part_2
-- Zone: 581, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58101

-- Converted from DG Script #58101: exit_room_58196_part_2
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: kannon kwan yin
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "kannon") or string.find(string.lower(speech), "kwan") or string.find(string.lower(speech), "yin")) then
    return true  -- No matching keywords
end
self.room:send("You can hear a faint voice say, 'I wish I could do more to help you...'")
self.room:send("Your vision blurs for a moment and there is a noise as of a rushing wind.")
self.room:teleport_all(get_room(581, 94))
get_room(581, 94):at(function()
    self.room:find_actor("all"):command("look")
end)