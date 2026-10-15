-- Trigger: lp_perfect
-- Zone: 43, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4351

-- Converted from DG Script #4351: lp_perfect
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"perfect", "act?", "act", "repertoire?", "repertoire"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
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