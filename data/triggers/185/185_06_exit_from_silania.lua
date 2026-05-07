-- Trigger: exit_from_silania
-- Zone: 185, ID: 6
-- Type: MOB, Flags: SPEECH
--
-- "Exit"/"exit?" → Silania apologetically opens the hidden passage
-- by manually firing 185_07.

if not string.find(string.lower(speech), "exit") then
    return true
end
self:say("Ooops, how embarassing, I forgot about the door!")
run_room_trigger(185, 7)