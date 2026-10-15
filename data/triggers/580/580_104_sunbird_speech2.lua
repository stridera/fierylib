-- Trigger: Sunbird_speech2
-- Zone: 580, ID: 104
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- After the Kannon cinematic, the Sunbird explains the conspiracy
-- around Yajiro and asks the player to investigate.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"what?", "what", "terrible?", "terrible", "something?", "something", "happened?", "happened"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(5)
self:command("nod")
wait(10)
self:say("A conspiracy has infected Odaishyozen.")
self:say("Shadowy figures have been plotting with Yajiro,")
self:say("the court sorcerer, to capture Kannons light.")
self:say("It seems they have even ensnared innocent souls in their trap.")
wait(12)
self:command("ponder")
wait(12)
self:say("But perhaps you can help untangle these threads of karma")
self:say("Will you investigate what has happened to Kannon?")