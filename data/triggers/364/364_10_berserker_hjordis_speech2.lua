-- Trigger: berserker_hjordis_speech2
-- Zone: 364, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #36410

-- Converted from DG Script #36410: berserker_hjordis_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
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
        actor:start_quest("berserker_subclass", "Ber")
        actor:send(tostring(self.name) .. " says, 'Then prove it!'")
        self:command("laugh")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'There are a few shared rites that bind us together.  None is more revered than the <b:cyan>Wild Hunt</>.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Ask your <b:cyan>[subclass progress]</> if you need guidance.'")
    end
end