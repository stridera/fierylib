-- Trigger: Tech_Master_Shaman_4
-- Zone: 550, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55004

-- Converted from DG Script #55004: Tech_Master_Shaman_4
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: keys
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "keys")) then
    return true  -- No matching keywords
end
-- Still more quest banter
self.room:send("The <b:yellow>Master Shaman</> nods.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'Whatever they are, no one even remembers")
actor:send("</>anymore.  They are just the means by which the greatest evils my kingdom has")
actor:send("</>ever known can be set free again.'")
self.room:send("The <b:yellow>Master Shaman</> frowns.")