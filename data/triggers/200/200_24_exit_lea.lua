-- Trigger: exit_lea
-- Zone: 200, ID: 24
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20024

-- Converted from DG Script #20024: exit_lea
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: exit
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "exit")) then
    return true  -- No matching keywords
end
self.room:send("The room suddenly becomes pitch dark and a bright flash of light erupts from the ground.")
self.room:spawn_object(200, 52)
wait(1)
self.room:send("Yix'Xyua says, 'Very well, on your way!'")
actor.name:command("enter portal")