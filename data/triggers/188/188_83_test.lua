-- Trigger: test
-- Zone: 188, ID: 83
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW (debug-only stub; original DG used eval, not portable)
--
-- Original DG Script: #18883
-- Converted from DG Script #18883: test
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)
--
-- TODO(parity): the legacy DG `eval %speech%` evaluated the spoken text as
-- DG-script. There is no Lua equivalent and shipping eval-of-player-input
-- would be a security hole. Either delete this trigger or replace with a
-- specific debug command list.

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"eval"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send("(debug) speech received: " .. tostring(speech))