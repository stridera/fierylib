-- Trigger: prince_speak1
-- Zone: 480, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48010

-- Converted from DG Script #48010: prince_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: trade?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "trade?")) then
    return true  -- No matching keywords
end
if actor.alignment > 350 and actor.level > 80 then
    wait(2)
    self:say("If you bring me the head of the king's dark champion, then I will give you an item that may help you in your battle with the king.")
    wait(1)
    self:say("According to our rules of dueling, you must say 'the prince wishes to challenge you by proxy', before starting the fight.")
    wait(1)
    self:command("smile")
    self:say("That way, I can claim the victory as my own.")
end