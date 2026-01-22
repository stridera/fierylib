-- Trigger: Trapped
-- Zone: 125, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12505

-- Converted from DG Script #12505: Trapped
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: trapped Trapped trapped? Trapped?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "trapped") or string.find(string.lower(speech), "trapped") or string.find(string.lower(speech), "trapped?") or string.find(string.lower(speech), "trapped?")) then
    return true  -- No matching keywords
end
wait(1)
self:say("They say the key is at the top of the tower. Watch your step though...")
wait(2)
self:say("When I tried, I fell through the floor, spraining my ankle.")
wait(2)
self:say("If you could free my brother, my family would be quite thankful.")
wait(2)
actor.name:send(tostring(self.name) .. " looks at you pleadingly.")
self.room:send_except(actor, tostring(self.name) .. " looks at " .. tostring(actor.name) .. " pleadingly.")