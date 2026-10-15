-- Trigger: Magistrate speech Wug
-- Zone: 30, ID: 33
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3033

-- Converted from DG Script #3033: Magistrate speech Wug
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"wug"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("dragon_slayer") == 3 then
    actor:send(tostring(self.name) .. " tells you, 'There is a temple just outside the West Gate")
    actor:send("</>of town dedicated to the Kaaz clan, the great heroes of the Rift Wars.")
    actor:send("Mystics from all around Caelia go there hoping to find some kind of special")
    actor:send("</>power.'")
    wait(0.4)
    actor:send(tostring(self.name) .. " tells you, 'They have discovered a secret chamber below")
    actor:send("</>the main temple.  It seems something down there has sealed away a whole slew of")
    actor:send("</>nasty draklings.'")
    wait(0.4)
    actor:send(tostring(self.name) .. " tells you, 'Legend has it they're repelled by powerful")
    actor:send("</>heroes like the Kaaz clan, but dragon slayers like you should be able to fight")
    actor:send("</>them without issue.'")
end