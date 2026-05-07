-- Trigger: Ill-subclass: Reveal the walkway
-- Zone: 172, ID: 10
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Player speaks the incantation "where the dough ever rises" while at the
-- waterfall (room 363:39). The hidden walkway becomes visible for ~8s,
-- then fades. Only fires if the player is at quest stage 4 (just learned
-- the incantation from Gannigan).
--
-- Original DG Script: #17210

local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "where")
    and string.find(speech_lower, "dough")
    and string.find(speech_lower, "rises")) then
    return true  -- not the full incantation
end

if actor:get_quest_stage("illusionist_subclass") ~= 4 then
    return true
end

wait(15)
self.room:send("The illusion falls like a sheet of water, revealing in a moment a walkway.")
self.room:send("It snakes eastward across the face of the falls, narrow and dangerous.")
get_room(363, 39):exit("east"):set_state({hidden = false, description = "A narrow walkway zigzags through the air."})
wait(8)
self.room:send("The walkway fades, revealing nothing but a misty drop into the waters below.")
get_room(363, 39):exit("east"):set_state({hidden = true, description = "The balcony ends at the waterfall.  Oddly, there is no railing at this end."})