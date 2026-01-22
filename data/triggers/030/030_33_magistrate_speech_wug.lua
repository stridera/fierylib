-- Trigger: Magistrate speech Wug
-- Zone: 30, ID: 33
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3033

-- Converted from DG Script #3033: Magistrate speech Wug
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: wug
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "wug")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("dragon_slayer") == 3 then
    actor:send(tostring(self.name) .. " tells you, 'There is a temple just outside the West Gate")
    actor:send("</>of town dedicated to the Kaaz clan, the great heroes of the Rift Wars.")
    actor:send("Mystics from all around Caelia go there hoping to find some kind of special")
    actor:send("</>power.'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'They have discovered a secret chamber below")
    actor:send("</>the main temple.  It seems something down there has sealed away a whole slew of")
    actor:send("</>nasty draklings.'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'Legend has it they're repelled by powerful")
    actor:send("</>heroes like the Kaaz clan, but dragon slayers like you should be able to fight")
    actor:send("</>them without issue.'")
end