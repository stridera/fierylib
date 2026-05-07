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

-- Speech keyword: scorpion
if not string.find(string.lower(speech), "scorpion") then
    return true
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