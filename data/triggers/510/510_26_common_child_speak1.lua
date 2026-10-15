-- Trigger: common_child_speak1
-- Zone: 510, ID: 26
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51026
-- Reacts to "kafit" — both heads of the two-headed child reveal
-- that "kafit" is the key to decoding Luchiaans' spells and beg the
-- adventurer for vengeance.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"kafit?", "kafit"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send("Both the child's heads focus their attention on you.")
self.room:send("One head says, 'That is the key to decoding Luchiaans' spells.'")
self.room:send("The other head says, 'Avenge us, adventurer!'")
self:command("beg " .. tostring(actor.name))