-- Trigger: Wise leprechaun discusses webs
-- Zone: 615, ID: 23
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61523

-- Converted from DG Script #61523: Wise leprechaun discusses webs
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"web", "webs", "web?", "webs?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.6)
self:say("If it's spiders that trouble ye, I'm the right one to help ye.")
self:say("Those webs are right tough, ain't they?")
wait(4)
self:say("I'll tell ye what.  Bring me one o' them pointy flint-knives,")
self:say("and a nice cherry, and I'll enchant it for ye sure.")
wait(3)
self:command("peer " .. tostring(actor.name))
wait(0.4)
self:say("Well, what be ye still doing here?  Scurry off with ye!")