-- Trigger: Ill-subclass: Reveal the walkway
-- Zone: 172, ID: 10
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17210

-- Converted from DG Script #17210: Ill-subclass: Reveal the walkway
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: where the dough ever rises
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "where") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "dough") or string.find(string.lower(speech), "ever") or string.find(string.lower(speech), "rises")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("illusionist_subclass") == 4 then
    wait(15)
    self.room:send("The illusion falls like a sheet of water, revealing in a moment a walkway.")
    self.room:send("It snakes eastward across the face of the falls, narrow and dangerous.")
    get_room(363, 39):exit("east"):set_state({hidden = false})
    get_room(363, 39):exit("east"):set_state({description = "A narrow walkway zigzags through the air."})
    wait(8)
    self.room:send("The walkway fades, revealing nothing but a misty drop into the waters below.")
    get_room(363, 39):exit("east"):set_state({hidden = false})
    get_room(363, 39):exit("east"):set_state({description = "The balcony ends at the waterfall.  Oddly, there is no railing at this end."})
end