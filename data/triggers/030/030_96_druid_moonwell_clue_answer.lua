-- Trigger: druid_moonwell_clue_answer
-- Zone: 30, ID: 96
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3096

-- Converted from DG Script #3096: druid_moonwell_clue_answer
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: punished
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "punished")) then
    return true  -- No matching keywords
end
if actor.class == "druid" then
    if actor.level >= 73 then
        wait(15)
        self:say("Yes, yes, but hopefully one day she'll be able to leave that tree.")
        wait(15)
    else
        wait(15)
        self:say("I'm sorry, but you are still too young.")
        wait(5)
        self:command("smile " .. tostring(actor.name))
        self:command("ruffle " .. tostring(actor.name))
    end
else
    self:say("I'm sorry, but it's okay.  Don't worry about it.")
    self:command("smile " .. tostring(actor.name))
end