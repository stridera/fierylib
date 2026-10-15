-- Trigger: exit_lea
-- Zone: 200, ID: 24
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20024

-- Converted from DG Script #20024: exit_lea
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"exit"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send("The room suddenly becomes pitch dark and a bright flash of light erupts from the ground.")
self.room:spawn_object(200, 52)
wait(0.1)
self.room:send("Yix'Xyua says, 'Very well, on your way!'")
actor:command("enter portal")