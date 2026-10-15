-- Trigger: exit_from_ziijhan
-- Zone: 85, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8505

-- Converted from DG Script #8505: exit_from_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"exit"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("sigh")
self:say("Sniveling mortal!")
actor:send("Ziijhan waves his arms in a circle and you are blinded by a flash of light!")
self.room:send_except(actor, "Ziijhan glares at " .. tostring(actor.name) .. " and sends " .. tostring(actor.object) .. " elsewhere!")
actor:teleport(get_room(85, 1))