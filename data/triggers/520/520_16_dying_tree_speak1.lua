-- Trigger: dying_tree_speak1
-- Zone: 520, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #52016

-- Converted from DG Script #52016: dying_tree_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help? hydra?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help?") or string.find(string.lower(speech), "hydra?")) then
    return true  -- No matching keywords
end
self:command("sigh")
self.room:send(tostring(self.name) .. " says, 'I was the Tree of Life, and now I live in agony")
self.room:send("</>thanks to the Hydra's fire.  Kill me, and take a branch to help you kill the")
self.room:send("</>Hydra.'")