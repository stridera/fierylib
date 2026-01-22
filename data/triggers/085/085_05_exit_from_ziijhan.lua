-- Trigger: exit_from_ziijhan
-- Zone: 85, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8505

-- Converted from DG Script #8505: exit_from_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: exit
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "exit")) then
    return true  -- No matching keywords
end
self:command("sigh")
self:say("Sniveling mortal!")
actor:send("Ziijhan waves his arms in a circle and you are blinded by a flash of light!")
self.room:send_except(actor, "Ziijhan glares at " .. tostring(actor.name) .. " and sends " .. tostring(actor.object) .. " elsewhere!")
actor:teleport(get_room(85, 1))