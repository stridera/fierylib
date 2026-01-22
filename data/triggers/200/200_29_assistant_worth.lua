-- Trigger: assistant_worth?
-- Zone: 200, ID: 29
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20029

-- Converted from DG Script #20029: assistant_worth?
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: prove?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "prove?")) then
    return true  -- No matching keywords
end
wait(1)
self:say("Yes, you must prove to us that you are able to complete any job we give you.")
wait(1)
self:command("ponder")
self:say("This is what you are to do..")
self:say("You will go to the place where Ruin is located,")
self:say("and there you will find a ball of light.")
wait(1)
self:say("Bring it to us and you will receive a prize and we will talk further.")
self:whisper(actor.name, "If you want to show us extra skill,")
self:whisper(actor.name, "you will bring us an oak staff,")
self:whisper(actor.name, "carved in the shape of a serpent.")
wait(1)
self:command("grin")
wait(1)
self:say("Now on your way.")
actor.name:teleport(get_room(200, 94))