-- Trigger: berserker_hjordis_speech1
-- Zone: 364, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #36409

-- Converted from DG Script #36409: berserker_hjordis_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"among", "among?", "number", "number?", "who", "who?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "warrior") then
    -- TODO(parity): legacy DG left placeholder for race restrictions:
    --   "Your race may not subclass to berserker." Restricted race list TBD.
    wait(0.2)
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'Aye, you have the mettle of the most fearsome of all warriors, a <b:black>ber<red>ser<black>ker</>!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Do you think you have what it takes?'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Build your rage further, then seek me out again.'")
    end
end