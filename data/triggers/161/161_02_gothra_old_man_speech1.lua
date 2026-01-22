-- Trigger: Gothra_Old_Man_speech1
-- Zone: 161, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16102

-- Converted from DG Script #16102: Gothra_Old_Man_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: precious
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "precious")) then
    return true  -- No matching keywords
end
self:command("sigh")
self.room:send_except(actor, "An old man speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("An old man whispers to you 'Yes, during our battles with a giant monster near here a gift from my dear wife was lost.'")
self:command("wince")
wait(1)
self:command("grumble")
actor:send("An old man whispers to you 'Wrecked up my cart real good too...'")
self.room:send_except(actor, "An old man speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("An old man whispers to you 'She wasn't happy, she's quite the rogue from a prominent merchant family and the bracelet was an heirloom.'")
self:command("frown")
actor:send("An old man whispers to you 'If I only had it back....'")