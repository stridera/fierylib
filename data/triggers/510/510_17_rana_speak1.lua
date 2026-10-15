-- Trigger: rana_speak1
-- Zone: 510, ID: 17
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51017
-- Reacts to "cleaner" — Rana laments her exile and her plans for
-- revenge on Luchiaans, who would burn her with magic if she got
-- close.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"cleaner?", "cleaner"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Yes...")
self:command("ponder")
self:say("I wonder where he is now, or even if he survived? The only reason I am still here is as a punishment.")
self:command("growl")
wait(0.1)
self:say("But if I ever catch that Luchiaans, I'll make him regret this.")
self:command("think")
self:say("Of course, as soon as I got within striking distance he'd fry me with his magic.")
self:command("sigh")
wait(0.1)
self:say("I will have to just plan my revenge for now.")
self:command("daydream")