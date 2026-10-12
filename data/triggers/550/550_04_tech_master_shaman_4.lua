-- Trigger: Tech_Master_Shaman_4
-- Zone: 550, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55004

-- Converted from DG Script #55004: Tech_Master_Shaman_4
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"keys"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Still more quest banter
self.room:send("The <b:yellow>Master Shaman</> nods.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'Whatever they are, no one even remembers")
actor:send("</>anymore.  They are just the means by which the greatest evils my kingdom has")
actor:send("</>ever known can be set free again.'")
self.room:send("The <b:yellow>Master Shaman</> frowns.")