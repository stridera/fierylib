-- Trigger: unused
-- Zone: 18, ID: 99
-- Type: WORLD, Flags: COMMAND, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1899

-- Converted from DG Script #1899: unused
-- Original: WORLD trigger, flags: COMMAND, SPEECH, probability: 100%

-- Command filter: reset_the_quest
if not (cmd == "reset_the_quest") then
    return true  -- Not our command
end

-- Speech keywords: reset_the_quest
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "reset_the_quest")) then
    return true  -- No matching keywords
end
-- (placeholder trigger)