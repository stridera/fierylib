-- Trigger: Trapped
-- Zone: 125, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12505

-- Converted from DG Script #12505: Trapped
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trapped", "trapped?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(1)
self:say("They say the key is at the top of the tower. Watch your step though...")
wait(2)
self:say("When I tried, I fell through the floor, spraining my ankle.")
wait(2)
self:say("If you could free my brother, my family would be quite thankful.")
wait(2)
actor:send(tostring(self.name) .. " looks at you pleadingly.")
self.room:send_except(actor, tostring(self.name) .. " looks at " .. tostring(actor.name) .. " pleadingly.")