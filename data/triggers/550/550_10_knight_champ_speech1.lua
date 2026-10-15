-- Trigger: Knight_Champ_speech1
-- Zone: 550, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55010

-- Converted from DG Script #55010: Knight_Champ_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"deities"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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