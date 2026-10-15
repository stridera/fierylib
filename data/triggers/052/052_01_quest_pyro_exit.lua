-- Trigger: quest_pyro_exit
-- Zone: 52, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5201
--
-- When a player asks Emmath about an "exit", he opens the flamewall,
-- pushes the actor west, then re-seals it. Other players in the room
-- have to ask separately if they want out.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"exit", "exit?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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
