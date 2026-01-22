-- Trigger: Infidel speech revenge
-- Zone: 480, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48028

-- Converted from DG Script #48028: Infidel speech revenge
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: revenge?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "revenge?")) then
    return true  -- No matching keywords
end
if actor.alignment < -349 then
    wait(2)
    self:command("grin")
    self:say("Many centuries ago, I was the champion of King Ureal, the mighty sorcerer who would conquer Ethilien.")
    wait(1)
    self:say("Some pathetic paladin sought to slay our King, claiming it was his duty to bring an end to his reign.")
    wait(1)
    self:say("He challenged me to a duel.")
    self:command("chuckle")
    wait(1)
    self:say("And lost.")
end