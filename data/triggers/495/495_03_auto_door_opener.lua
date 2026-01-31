-- Trigger: Auto door opener
-- Zone: 495, ID: 3
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49503

-- Converted from DG Script #49503: Auto door opener
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I am child of Borgan!
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "am") or string.find(string.lower(speech), "child") or string.find(string.lower(speech), "of") or string.find(string.lower(speech), "borgan!")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Necromancer") then
    get_room(495, 13):exit("up"):set_state({hidden = false})
    self.room:send("With a terrifying crash the ceiling above falls downward, ceasing. A stairway leads upwards.")
    wait(20)
    get_room(495, 13):exit("u"):set_state({hidden = true})
end