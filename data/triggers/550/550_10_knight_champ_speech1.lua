-- Trigger: Knight_Champ_speech1
-- Zone: 550, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55010

-- Converted from DG Script #55010: Knight_Champ_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: deities
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "deities")) then
    return true  -- No matching keywords
end
self:command("spit")
self.room:send_except(actor, "The Knight Champion speaks in a low voice to " .. tostring(actor.name) .. ".")
actor:send("The Knight Champion whispers to you, 'Xapizo the nemesis of death and that war")
actor:send("</>god!'")
wait(1)
self:command("growl")
self.room:send_except(actor, "The Knight Champion speaks in a low voice to " .. tostring(actor.name) .. ".")
actor:send("The Knight Champion whispers to you, 'They were nearly our undoing!'")
wait(1)
self:command("eye")
actor:send("The Knight Champion whispers to you, 'To destroy Xapizo, now there would be a")
actor:send("</>battle to earn respect! I wish I were so strong.'")