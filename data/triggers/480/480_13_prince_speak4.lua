-- Trigger: prince_speak4
-- Zone: 480, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48013

-- Converted from DG Script #48013: prince_speak4
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: help?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help?")) then
    return true  -- No matching keywords
end
if actor.alignment > 349 then
    wait(2)
    self:command("sigh")
    self:say("Many years ago when King Ureal threatened the land, I swore that I would try to stop him.")
    wait(1)
    self:say("I was the paladin champion, and it was my duty to bring an end to his evil.")
    wait(1)
    self:emote("sighs again loudly.")
    self:say("But I failed.")
end