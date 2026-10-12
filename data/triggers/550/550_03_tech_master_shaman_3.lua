-- Trigger: Tech_Master_Shaman_3
-- Zone: 550, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55003

-- Converted from DG Script #55003: Tech_Master_Shaman_3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"evils"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Yet more quest information
self.room:send_except(actor, "The <b:yellow>Master Shaman</> raises an eyebrow at " .. tostring(actor.name) .. ".")
actor:send("The <b:yellow>Master Shaman</> raises an eyebrow at you.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'Yes, Huitzipa the war god and that cursed")
actor:send("</>death god, I can't even say his name.'")
self.room:send("The <b:yellow>Master Shaman</> spits over her shoulder.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'If it weren't for the great Snow Leopard of")
actor:send("</>the ancient age, our kingdom would have perished long long ago.'")
self.room:send("The <b:yellow>Master Shaman</> nods to herself.")