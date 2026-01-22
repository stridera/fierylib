-- Trigger: Ranger Quest Spell Hints
-- Zone: 1, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #112

-- Converted from DG Script #112: Ranger Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: blur
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "blur")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
-- switch on speech
if string.find(self.class, "ranger") then
    if speech == "blur" then
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
    _return_value = false
end
return _return_value