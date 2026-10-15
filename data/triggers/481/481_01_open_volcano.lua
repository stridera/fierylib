-- Trigger: open_volcano
-- Zone: 481, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48101

-- Converted from DG Script #48101: open_volcano
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- Speech phrase: buntoi nakkarri karisto (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]buntoi nakkarri karisto[%s%p]") then
    return true  -- Not the phrase
end
get_room(481, 48):at(function()
    self.room:send("There is a load groaning noise and a crack develops in the side of the volcano.")
end)
get_room(481, 47):at(function()
    self.room:send("There is a load groaning noise and a crack develops in the side of the volcano.")
end)
wait(2)
get_room(481, 47):at(function()
    self.room:send("Even as you watch the crack widens to the size of a doorway.")
end)
get_room(481, 48):at(function()
    self.room:send("Even as you watch the crack widens to the size of a doorway.")
end)
get_room(481, 47):exit("north"):set_state({hidden = false})
get_room(481, 47):exit("north"):set_state({description = "A passage leads into the heart of the volcano."})
get_room(481, 48):exit("south"):set_state({hidden = false})
get_room(481, 48):exit("south"):set_state({description = "You can see the sky through the doorway!"})
wait(10)
get_room(481, 47):at(function()
    self.room:send("There is a load groaning noise and the doorway starts to close!")
end)
get_room(481, 48):at(function()
    self.room:send("There is a load groaning noise and the doorway starts to close!")
end)
wait(2)
get_room(481, 47):at(function()
    self.room:send("The volcano shudders as it seals the entrance.")
end)
get_room(481, 48):at(function()
    self.room:send("The volcano shudders as it seals the entrance.")
end)
get_room(481, 47):exit("north"):set_state({hidden = true})
get_room(481, 48):exit("south"):set_state({hidden = true})