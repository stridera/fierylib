-- Trigger: test_trig
-- Zone: 12, ID: 33
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1233

-- Converted from DG Script #1233: test_trig
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hello
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hello")) then
    return true  -- No matching keywords
end
self:say(tostring(actor.name) .. " is a " .. tostring(actor.class) .. ".")
if actor:get_quest_stage("moonwell_spell_quest") > 0 then
    self:say(tostring(actor.name) .. " is on the moonwell quest.")
else
    self:say(tostring(actor.name) .. " is not on the moonwell quest.")
end