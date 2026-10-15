-- Trigger: Diabolist Quest Spell Hints
-- Zone: 1, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #108

-- Converted from DG Script #108: Diabolist Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hell", "hell?", "hellfire", "hellfire?", "brimstone", "brimstone?", "fire", "fire?"}) do
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
    if _sw1 == "hell" or _sw1 == "hell?" then
        if string.find(self.class, "diabolist") then
            self:say("Our infernal lords do grant us the power to open a")
            self.room:send("'<b:red>Hell Gate</> to travel anywhere instantly via the Nine Hells.'")
            -- (empty room echo)
            self.room:send("'Places where Garl'lixxil have touched Ethilienm, like Templace, are'")
            self.room:send("'particularly suitable for attuning to the proper energies.'")
        elseif string.find(self.class, "priest") then
            self:say("Members of priestly orders travel by the Will of")
            self.room:send("'Heaven. We do not spread the knowledge of Infernal magics.'")
        elseif string.find(self.class, "druid") then
            self:say("We move by the power of the Moon,")
            self.room:send("'not the Nine Hells.'")
        else
            self:say("We have no knowledge of that spell in our Guild.")
        end
    elseif _sw1 == "hellfire" or _sw1 == "hellfire?" or _sw1 == "brimstone" or _sw1 == "brimstone?" or _sw1 == "fire" or _sw1 == "fire?" then
        if string.find(self.class, "diabolist") then
            self:say("There is a cult on the edge of South Caelia known")
            self.room:send("'for conjuring <b:red>Hellfire and Brimstone</>. Their dark leader holds the keys'")
            self.room:send("'to the spell.'")
        elseif string.find(self.class, "priest") or string.find(self.class, "cleric") then
            self:say("We do not dabble in such unholy magics.")
        elseif string.find(self.class, "pyromancer") then
            self:say("Unfortunately I don't know much about that spell,")
            self.room:send("'but I sure would love to...'")
        else
            self:say("That spell isn't part of our magical tradition.")
        end
    else
        _return_value = true
    end
end
return _return_value