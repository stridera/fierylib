-- Trigger: prisoner_yes
-- Zone: 590, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #59011

-- Converted from DG Script #59011: prisoner_yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(4)
if actor:get_quest_stage("sacred_haven") >= 2 and actor.id == -1 and actor.level < 100 then
    self:command("grin")
    actor:send(tostring(self.name) .. " whispers to you, 'Good, we have been trying to retrieve")
    actor:send("</>our stolen artifacts when I was captured and place here.'")
    wait(5)
    actor:send(tostring(self.name) .. " whispers to you, 'I've learned of the location of")
    actor:send("</>the earring.  It's locked in a chest.'")
end