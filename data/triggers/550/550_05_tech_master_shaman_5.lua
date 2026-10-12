-- Trigger: Tech_Master_Shaman_5
-- Zone: 550, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55005

-- Converted from DG Script #55005: Tech_Master_Shaman_5
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"huitzipa"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- More quest conversation
self.room:send("The <b:yellow>Master Shaman</> blinks.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'How dare you repeat that vile name in my")
actor:send("</>presence!  If it were not for the Great Leopard we would be lost.  The")
actor:send("</>injustice and recklessness of them, I wish him destroyed!'")
self.room:send("The <b:yellow>Master Shaman</> growls.")