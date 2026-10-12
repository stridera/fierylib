-- Trigger: priestess_speech4
-- Zone: 123, ID: 4
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12304

-- Converted from DG Script #12304: priestess_speech4
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"slipping", "how", "what"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech, "slipping away") or string.find(speech, "slipping away?") or string.find(speech, "how terrible") or string.find(speech, "how sad") or string.find(speech, "what can be done?") then
    wait(2)
    self:say("We began to lose hope until we found this ancient circle of standing stones.  But I believe this place is powerful enough for us to perform the Great Invocation Rite.")
    wait(4)
    self:say("Several of our sacred prophetic implements were damaged navigating the maze.  My Sisters are too busy tending to their duties preparing this site for the Great Rite to find suitable replacements.")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'But perhaps you would be willing to <b:cyan>help us?</>'")
end