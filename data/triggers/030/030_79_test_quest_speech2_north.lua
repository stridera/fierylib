-- Trigger: test_quest_speech2_north
-- Zone: 30, ID: 79
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3079

-- Converted from DG Script #3079: test_quest_speech2_north
-- Original: MOB trigger, flags: SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
if actor.id == -1 then
    if actor:get_quest_stage("zzurs_funky_quest") == 2 then
        actor:send(tostring(self.name) .. " says to you, 'I would love to send him proof of my doings but I am so busy.'")
        self:command("sigh")
        actor:send(tostring(self.name) .. " says to you, 'I need a diadem of bone.'")
        actor.name:advance_quest("zzurs_funky_quest")
    else
    end
else
end