-- Trigger: academy_clerk_speech_hit_points
-- Zone: 519, ID: 86
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51986

-- Converted from DG Script #51986: academy_clerk_speech_hit_points
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: hit points (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]hit points[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
if actor:get_quest_stage("school") == 2 then
    actor:set_quest_var("school", "hp", "complete")
    actor:send(tostring(self.name) .. " tells you, 'Look at the prompt in the lower-left corner of your screen again.")
    actor:send("The two numbers on the left are your <b:red>Hit Points</>.")
    actor:send("The first number is your <b:red>Current Hit Points</>.")
    actor:send("The second number is your <b:red>Maximum Hit Points</>.")
    actor:send("Your <b:red>Maximum</> increases every time you level.")
    actor:send("</>")
    actor:send("When you get hit in combat, your current Hit Points go down.")
    actor:send("If your Hit Points reach 0, you die.")
    actor:send("So <b:cyan>FLEE</> or heal before they run low.")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Are you ready to continue?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end