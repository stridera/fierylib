-- Trigger: Gothra_Old_Man_speech2
-- Zone: 161, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16103
--
-- When the player mentions "scorpion", the old man brags that he trapped (but
-- could not slay) the giant beast, and hints that the battle cost him
-- something precious.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"scorpion"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("grin " .. tostring(actor.name))
self:say("Oh yea...")
self:command("smile man")
self.room:send_except(actor, "An old man speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("An old man whispers to you 'I was able to trick the vile beast and trap it.'")
wait(0.1)
actor:send("An old man whispers to you 'It was a bit too mighty for me and my men to actually slay.'")
self:command("sigh")
self.room:send_except(actor, "An old man speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("An old man whispers to you 'The battle was quite brutal. Like another time I lost something precious.'")
self:command("frown")