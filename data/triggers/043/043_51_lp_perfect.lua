-- Trigger: lp_perfect
-- Zone: 43, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4351

-- Converted from DG Script #4351: lp_perfect
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: perfect act?  repertoire?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "perfect") or string.find(string.lower(speech), "act?") or string.find(string.lower(speech), "repertoire?")) then
    return true  -- No matching keywords
end
wait(2)
self:emote("presents himself with grand poise.")
self.room:send(tostring(self.name) .. " says, 'Yes, our grand Finale, never before seen on a public")
self.room:send("</>stage!'")
wait(3)
self:command("eye " .. tostring(actor.name))
wait(3)
self.room:send(tostring(self.name) .. " says, 'This is not something for just anyone.  The Finale is")
self.room:send("</>only for someone spectacular, with great dreams and aspirations.  One who is")
self.room:send("</>ready for one last, perfect act.  For one brief moment, they will shine like")
self.room:send("</>the sun itself.'")
wait(4)
self:emote("gives you a very warning look.")
wait(3)
self:say("Once you enter that place, there is no going back.")