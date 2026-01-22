-- Trigger: academy_clerk_speech_hit_points
-- Zone: 519, ID: 86
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51986

-- Converted from DG Script #51986: academy_clerk_speech_hit_points
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: hit points
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hit") or string.find(string.lower(speech), "points")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 2 then
    actor:set_quest_var("school", "hp", "complete")
    actor:send(tostring(self.name) .. " tells you, 'Look at the prompt in the lower-left corner of your screen again.")
    actor:send("The two numbers on the left are your <b:red>Hit Points</>.")
    actor:send("The first number is your <b:red>Current Hit Points</>.")
    actor:send("The second number is your <b:red>Maximum Hit Points</>.")
    actor:send("Your <b:red>Maximum</> increases every time you level.")
    actor:send("</>")
    actor:send("When you get hit in combat, your current Hit Points go down.")
    actor:send("If your Hit Points reach 0, you are knocked unconscious.")
    actor:send("If your Hit Points reach -10, you die.")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Are you ready to continue?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end