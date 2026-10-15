-- Trigger: assistant_worth?
-- Zone: 200, ID: 29
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20029

-- Converted from DG Script #20029: assistant_worth?
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"prove?", "prove"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.1)
self:say("Yes, you must prove to us that you are able to complete any job we give you.")
wait(0.1)
self:command("ponder")
self:say("This is what you are to do..")
self:say("You will go to the place where Ruin is located,")
self:say("and there you will find a ball of light.")
wait(0.1)
self:say("Bring it to us and you will receive a prize and we will talk further.")
self:whisper(actor.name, "If you want to show us extra skill,")
self:whisper(actor.name, "you will bring us an oak staff,")
self:whisper(actor.name, "carved in the shape of a serpent.")
wait(0.1)
self:command("grin")
wait(0.1)
self:say("Now on your way.")
actor:teleport(get_room(200, 94))