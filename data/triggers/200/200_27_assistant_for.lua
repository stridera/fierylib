-- Trigger: assistant_for?
-- Zone: 200, ID: 27
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20027

-- Converted from DG Script #20027: assistant_for?
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: for?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "for?")) then
    return true  -- No matching keywords
end
self:say("Yes for.")
self:command("sigh")
wait(1)
self.room:send("Yix'Xyua whispers something to the assistant.")
self:say("Have you come here to assist us in our problem with Ruin Wormheart?")