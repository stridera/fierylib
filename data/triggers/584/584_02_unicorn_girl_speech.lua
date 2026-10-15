-- Trigger: Unicorn girl speech
-- Zone: 584, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58402

-- Converted from DG Script #58402: Unicorn girl speech
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)


-- Speech keyword: "wrong"
-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"wrong"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

wait(0.1)
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'The King will not free me, even though my obligation of service to him is done.  He shall never have my hand in marriage, thus I shall remain his slave forever.'")