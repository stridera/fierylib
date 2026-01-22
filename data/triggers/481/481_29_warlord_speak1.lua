-- Trigger: warlord_speak1
-- Zone: 481, ID: 29
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48129

-- Converted from DG Script #48129: warlord_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: son?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "son?")) then
    return true  -- No matching keywords
end
wait(2)
self.room:send(tostring(self.name) .. " says, 'Yes, he was kidnapped by the Bone Tribe head-hunters for a sacrifice.'")
wait(1)
self:command("spit")
self.room:send(tostring(self.name) .. " says, 'Those headhunters are scum, and their chief is the worst of them.  If only I had warriors to spare, I could attack and kill him.'")
self:command("glare")
wait(1)
self.room:send(tostring(self.name) .. " says, 'He carries my father's shriveled head on his belt, and now he has taken my son too.'")