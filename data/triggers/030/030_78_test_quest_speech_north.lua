-- Trigger: test_quest_speech_north
-- Zone: 30, ID: 78
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3078

-- Converted from DG Script #3078: test_quest_speech_north
-- Original: MOB trigger, flags: SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
if actor.id == -1 then
    if actor:get_quest_stage("zzurs_funky_quest") == 1 then
        actor:send(tostring(self.name) .. " says to you, 'My brother is looking for me?'")
        actor.name:advance_quest("zzurs_funky_quest")
    else
    end
else
end