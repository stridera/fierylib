-- Trigger: fire_goddess_who
-- Zone: 43, ID: 37
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4337

-- Converted from DG Script #4337: fire_goddess_who
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"who?", "who", "he?", "he", "him?", "him"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self.room:send(tostring(self.name) .. " says, 'Pippin of course!  He's our star of this production.")
self.room:send("</> He's the last thing we need for our grand finale.'")
wait(2)
self.room:send(tostring(self.name) .. " says, 'Of course we can't find him, what with the monkey")
self.room:send("</>invasion earlier.  All of our props and costumes got all messed up, and now our")
self.room:send("</>star has gone missing too!'")
wait(3)
self:say("Talk to the House Gnome King and see about getting that straightened out.")