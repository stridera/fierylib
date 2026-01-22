-- Trigger: shaman_speak1
-- Zone: 481, ID: 34
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48134

-- Converted from DG Script #48134: shaman_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help? aid? yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help?") or string.find(string.lower(speech), "aid?") or string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(2)
self.room:send(tostring(self.name) .. " says, 'Vulcera has prevented us from making our customary sacrifices by placing one of her...'")
wait(2)
self:command("ponder")
wait(2)
self.room:send(tostring(self.name) .. " says, '\"pets\" in our sacred area before the volcano, and I fear that if we do not make a sacrifice soon...'")
wait(1)
self:command("shrug")
self:say("Well, the volcano will most likely blow up the island.")
self:command("sigh")
wait(1)
self.room:send(tostring(self.name) .. " says, 'If you can bring me the dragon head of the chimera, then I can reward you richly.'")
self:command("wink " .. tostring(actor.name))