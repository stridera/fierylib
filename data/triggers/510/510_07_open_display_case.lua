-- Trigger: open_display_case
-- Zone: 510, ID: 7
-- Type: WORLD, Flags: SPEECH
--
-- Original DG Script: #51007
-- Reacts to the password "amehs": collapses the display case in this
-- room and reveals the damaged book (510, 22). A spare display case
-- prototype is reloaded into the holding room (510, 99) so the next
-- reset will have one to place. Latched by `got_book`.

-- Speech keyword: "amehs"
if not string.find(string.lower(speech or ""), "amehs") then
    return true
end

if got_book == 1 then
    actor:send("You marvel at the resonant tones of your voice, perhaps you should be an actor.")
    return true
end

self.room:send("The display case folds and collapses to the floor.")
local case = self.room:find_object("display-case")
if case then
    world.destroy(case)
end
self.room:spawn_object(510, 22)
-- Stash a spare display case in the holding area so a future reset
-- has one to drop here.
get_room(510, 99):spawn_object(510, 21)
globals.got_book = 1
