-- Trigger: Cirion_speech1
-- Zone: 370, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #37005

-- Converted from DG Script #37005: Cirion_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: slaves slaves?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "slaves") or string.find(string.lower(speech), "slaves?")) then
    return true  -- No matching keywords
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Our bodies are getting old, and are starting to decay, but'")
actor:send(tostring(self.name) .. " says to you, 'our minds and souls are still strong. Now he can kill us,'")
actor:send(tostring(self.name) .. " says to you, 'and set our spirits free. Freedom here I come!'")
self:command("thank " .. tostring(actor.name))