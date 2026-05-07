-- Trigger: bl_status
-- Zone: 41, ID: 17
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Reports the player's Black_Legion quest faction standings on either side
-- when they say "faction" or "status".
-- Original DG probability was 0% (a DG idiom for "speech-keyword gated only,
-- never random"). The converter-generated `percent_chance(0)` gate has been
-- removed because it would suppress the trigger entirely.
--
-- Original DG Script: #4117

-- Speech keywords: faction status
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "faction") or string.find(speech_lower, "status")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You are pledged to the Black Legion.'")
end
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You are pledged to the Eldorian Guard.'")
end
actor:send("</>Your progress with our cause is as follows:")
actor:send("</>Faction with The Black Legion: " .. tostring(actor:get_quest_var("black_legion:bl_faction")))
actor:send("</>Faction with The Eldorian Guard: " .. tostring(actor:get_quest_var("black_legion:eg_faction")))