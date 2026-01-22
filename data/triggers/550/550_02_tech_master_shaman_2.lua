-- Trigger: Tech_Master_Shaman_2
-- Zone: 550, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55002

-- Converted from DG Script #55002: Tech_Master_Shaman_2
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: missing
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "missing")) then
    return true  -- No matching keywords
end
-- This is the initial conversation to get quest data
self.room:send("The <b:yellow>Master Shaman</> rolls her eyes in disgust.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'Yes, my predecessors and ancestors lost many")
actor:send("</>battles with demons and a cult of the followers of Lokari and in the process")
actor:send("</>lost the keys.'")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks in a low voice to " .. tostring(actor.name) .. ".")
self.room:send("The <b:yellow>Master Shaman</> pulls out her unused thinking cap, and begins to think.")