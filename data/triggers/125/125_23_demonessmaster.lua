-- Trigger: DemonessMaster
-- Zone: 125, ID: 23
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12523

-- Converted from DG Script #12523: DemonessMaster
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: master Master
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "master") or string.find(string.lower(speech), "master")) then
    return true  -- No matching keywords
end
wait(1)
self.room:send(tostring(self.name) .. " says, 'Yes, my master.  We're to keep the unworthy out, to give")
self.room:send("</>him peace.'")
wait(2)
self:say("I don't know what to do with you.  Perhaps he will know.")
self:emote("primly folds her hands, closes her eyes, and becomes motionless.")
wait(10)
actor:send(tostring(self.name) .. " opens her eyes and refocuses them upon you.")
self.room:send_except(actor, tostring(self.name) .. " opens her eyes, and refocuses them upon " .. tostring(actor.name) .. ".")
wait(2)
self:say("Very well, you may enter...  if you dare.")
wait(1)
world.destroy(self.room:find_actor("portal"))
self.room:spawn_object(125, 43)
self:emote("waves her hand, causing the visage of a demon to appear.")