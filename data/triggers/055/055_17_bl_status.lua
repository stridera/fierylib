-- Trigger: bl_status
-- Zone: 55, ID: 17
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #5517

-- Converted from DG Script #5517: bl_status
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: faction status
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "faction") or string.find(string.lower(speech), "status")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You are pledged to the Black")
    actor:send("</>Legion.'")
end
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You are pledged to the")
    actor:send("</>Eldorian Guard.'")
end
-- (empty send to actor)
actor:send("Your progress with our cause is as follows:</>")
actor:send("Faction with The Black Legion: " .. tostring(actor:get_quest_var("black_legion:bl_faction")) .. "</>")
actor:send("Faction with The Eldorian Guard: " .. tostring(actor:get_quest_var("black_legion:eg_faction")) .. "</>")