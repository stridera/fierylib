-- Trigger: dwarven_exit_load
-- Zone: 16, ID: 86
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1686

-- Converted from DG Script #1686: dwarven_exit_load
-- Original: MOB trigger, flags: SPEECH, probability: 100%

local speech_lower = string.lower(speech)

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech_lower, "yes") then
    self:say("Excellent, come with me then!  I know another way out!")
    wait(2)
    self:emote("cautiously moves toward the back of the cell.")
    wait(3)
    self.room:send("A haggard dwarf scratches at some rocks in the wall.")
    run_room_trigger(16, 85)
end
if string.find(speech_lower, "no") then
    self:say("Then you are not friend to us!")
    combat.engage(actor)
end