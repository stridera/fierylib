-- Trigger: stormchild tank
-- Zone: 488, ID: 54
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48854

-- Converted from DG Script #48854: stormchild tank
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: Stop it,
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "stop") or string.find(string.lower(speech), "it,")) then
    return true  -- No matching keywords
end
if actor.id == 48806 then
    local tank = speech
    globals.tank = globals.tank or true
end