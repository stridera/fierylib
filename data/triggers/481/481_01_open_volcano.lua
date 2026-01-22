-- Trigger: open_volcano
-- Zone: 481, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48101

-- Converted from DG Script #48101: open_volcano
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: buntoi nakkarri karisto
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "buntoi") or string.find(string.lower(speech), "nakkarri") or string.find(string.lower(speech), "karisto")) then
    return true  -- No matching keywords
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
doors.set_state(get_room(481, 47), "north", {action = "room"})
doors.set_description(get_room(481, 47), "north", "A passage leads into the heart of the volcano.")
doors.set_state(get_room(481, 48), "south", {action = "room"})
doors.set_description(get_room(481, 48), "south", "You can see the sky through the doorway!")
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
doors.set_state(get_room(481, 47), "north", {action = "purge"})
doors.set_state(get_room(481, 48), "south", {action = "purge"})