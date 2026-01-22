-- Trigger: exit_from_raph
-- Zone: 133, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13303

-- Converted from DG Script #13303: exit_from_raph
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: exit exit?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "exit") or string.find(string.lower(speech), "exit?")) then
    return true  -- No matching keywords
end
-- to make this generic use %self.name% instead of raph, room is toughter..
self:command("growl")
self:say("You are too cruel!")
actor:send("Raph taps his wrists together and you are covered in smoke!")
self.room:send_except(actor, "Raph glares at " .. tostring(actor.name) .. " and sends him elsewhere!")
actor:teleport(get_room(133, 1))