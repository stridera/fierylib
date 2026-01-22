-- Trigger: rana_speak1
-- Zone: 510, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51017

-- Converted from DG Script #51017: rana_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: cleaner?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "cleaner?")) then
    return true  -- No matching keywords
end
self:say("Yes...")
self:command("ponder")
self:say("I wonder where he is now, or even if he survived? The only reason I am still here is as a punishment.")
self:command("growl")
wait(1)
self:say("But if I ever catch that Luchiaans, I'll make him regret this.")
self:command("think")
self:say("Of course, as soon as I got within striking distance he'd fry me with his magic.")
self:command("sigh")
wait(1)
self:say("I will have to just plan my revenge for now.")
self:command("daydream")