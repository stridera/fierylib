-- Trigger: Gothra_Old_Man_speech2
-- Zone: 161, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16103

-- Converted from DG Script #16103: Gothra_Old_Man_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: scorpion
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "scorpion")) then
    return true  -- No matching keywords
end
self:command("grin " .. tostring(actor.name))
self:say("Oh yea...")
self:command("smile man")
self.room:send_except(actor, "An old man speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("An old man whispers to you 'I was able to trick the vile beast and trap it.'")
wait(1)
actor:send("An old man whispers to you 'It was a bit too mighty for me and my men to actually slay.'")
self:command("sigh")
self.room:send_except(actor, "An old man speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("An old man whispers to you 'The battle was quite brutal. Like another time I lost something precious.'")
self:command("frown")