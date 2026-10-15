-- Trigger: Ranger Quest Spell Hints
-- Zone: 1, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #112

-- Converted from DG Script #112: Ranger Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"blur"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
-- switch on speech
do
    local _sw1 = string.lower(tostring(speech or ""))
    if _sw1 == "blur" then
        if string.find(self.class, "ranger") then
            self:say("After proving your dedication to the spirits of")
            self.room:send("'nature you must triumph in a challenge against the Four Winds to learn <b:green>Blur</>.'")
            -- (empty room echo)
            self.room:send("'Investigating and ending an eternal conflict in a forest would be an ideal'")
            self.room:send("'way to demonstrate your devotion to the natural world.'")
        else
            self:say("That spell is fiercely guarded by")
            self.room:send("'the Ranger Guild.'")
        end
    else
        _return_value = true
    end
end
return _return_value