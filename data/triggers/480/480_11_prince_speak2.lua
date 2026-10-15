-- Trigger: prince_speak2
-- Zone: 480, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48011

-- Converted from DG Script #48011: prince_speak2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"destroy?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment > 350 then
    if actor.level > 80 then
        wait(0.2)
        self:say("Yes.  He is still alive due to his magic arts, and so he can still be killed.")
        wait(0.1)
        self:say("He is a coward, however, and I have heard that when the tides of battle turn against him, he is quick to disappear.")
        self:say("I may have something to help you with that if you are willing to... trade.")
    else
        wait(0.2)
        self:say("Sadly yes, you have come too soon.  If you are able to return once you are stronger, perhaps you can be of great assistance then.")
    end
end