-- Trigger: Tech_Master_Shaman_3
-- Zone: 550, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55003

-- Converted from DG Script #55003: Tech_Master_Shaman_3
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: evils
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "evils")) then
    return true  -- No matching keywords
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