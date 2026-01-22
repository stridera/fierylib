-- Trigger: Wise leprechaun discusses webs
-- Zone: 615, ID: 23
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61523

-- Converted from DG Script #61523: Wise leprechaun discusses webs
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: web webs web? webs?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "web") or string.find(string.lower(speech), "webs") or string.find(string.lower(speech), "web?") or string.find(string.lower(speech), "webs?")) then
    return true  -- No matching keywords
end
wait(6)
self:say("If it's spiders that trouble ye, I'm the right one to help ye.")
self:say("Those webs are right tough, ain't they?")
wait(4)
self:say("I'll tell ye what.  Bring me one o' them pointy flint-knives,")
self:say("and a nice cherry, and I'll enchant it for ye sure.")
wait(3)
self:command("peer " .. tostring(actor.name))
wait(4)
self:say("Well, what be ye still doing here?  Scurry off with ye!")