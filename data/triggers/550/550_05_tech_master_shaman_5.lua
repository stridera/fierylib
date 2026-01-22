-- Trigger: Tech_Master_Shaman_5
-- Zone: 550, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55005

-- Converted from DG Script #55005: Tech_Master_Shaman_5
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: huitzipa
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "huitzipa")) then
    return true  -- No matching keywords
end
-- More quest conversation
self.room:send("The <b:yellow>Master Shaman</> blinks.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'How dare you repeat that vile name in my")
actor:send("</>presence!  If it were not for the Great Leopard we would be lost.  The")
actor:send("</>injustice and recklessness of them, I wish him destroyed!'")
self.room:send("The <b:yellow>Master Shaman</> growls.")