-- Trigger: quest_pyro_exit
-- Zone: 52, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5201

-- Converted from DG Script #5201: quest_pyro_exit
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: exit exit?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "exit") or string.find(string.lower(speech), "exit?")) then
    return true  -- No matching keywords
end
self.room:send("Emmath Firehand sighs loudly.")
self.room:send("Emmath Firehand says, 'Oh very well, I suppose it is time you left anyway.'")
self.room:send("Emmath Firehand grumbles incoherently about something or other.")
wait(1)
self.room:send("Emmath Firehand opens the flamewall with a wave of his hand.")
get_room(52, 20):exit("west"):set_state({has_door = true})
self.room:send_except(actor, "Emmath Firehand pushes " .. tostring(actor.name) .. " through the flamewall.")
actor:send("Emmath Firehand pushes you through the flamewall.")
actor:move("west")
wait(3)
self.room:send("Emmath Firehand says, 'I think you all should leave as well.'")
wait(2)
self.room:send("Emmath Firehand says, 'You had your chance, now it will just be more work for both of us for you to leave.'")
wait(1)
self.room:send("The flamewall reseals itself.")
get_room(52, 20):exit("west"):set_state({has_door = true, closed = true, locked = true, pickproof = true})