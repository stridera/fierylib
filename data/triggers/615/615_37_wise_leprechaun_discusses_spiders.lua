-- Trigger: Wise leprechaun discusses spiders
-- Zone: 615, ID: 37
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61537

-- Converted from DG Script #61537: Wise leprechaun discusses spiders
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: spiders spiders?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "spiders") or string.find(string.lower(speech), "spiders?")) then
    return true  -- No matching keywords
end
wait(4)
self:say("They've been terrorizing us for a long time now.")
self:say("But I know how to defeat their webs.")
wait(3)
self:command("ponder")
wait(2)
self:say("I suppose I could help you... if you give me a cherry!")
self:say("And if you do, I'll enchant a knife if you want.")
self:say("Of course, only one of these flint knives will do the trick.")