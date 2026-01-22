-- Trigger: test_quest_banter1
-- Zone: 30, ID: 76
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3076

-- Converted from DG Script #3076: test_quest_banter1
-- Original: MOB trigger, flags: SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
if not actor:get_has_completed("zzurs_funky_quest") then
    self:say("I wonder if my brother the Northern road ranger is still alive?")
    self:command("sigh")
    self:say("If only I had some proof of his doings.")
    self:say("Will you help me?")
else
end