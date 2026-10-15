-- Trigger: test_trig
-- Zone: 12, ID: 33
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1233

-- Converted from DG Script #1233: test_trig
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hello"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say(tostring(actor.name) .. " is a " .. tostring(actor.class) .. ".")
if actor:get_quest_stage("moonwell_spell_quest") > 0 then
    self:say(tostring(actor.name) .. " is on the moonwell quest.")
else
    self:say(tostring(actor.name) .. " is not on the moonwell quest.")
end