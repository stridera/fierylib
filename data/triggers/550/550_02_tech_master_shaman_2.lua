-- Trigger: Tech_Master_Shaman_2
-- Zone: 550, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55002

-- Converted from DG Script #55002: Tech_Master_Shaman_2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"missing"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- This is the initial conversation to get quest data
self.room:send("The <b:yellow>Master Shaman</> rolls her eyes in disgust.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'Yes, my predecessors and ancestors lost many")
actor:send("</>battles with demons and a cult of the followers of Lokari and in the process")
actor:send("</>lost the keys.'")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks in a low voice to " .. tostring(actor.name) .. ".")
self.room:send("The <b:yellow>Master Shaman</> pulls out her unused thinking cap, and begins to think.")