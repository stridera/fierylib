-- Trigger: eldest_speak2
-- Zone: 490, ID: 32
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49032

-- Converted from DG Script #49032: eldest_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: griffin? griffins? griffins griffin griffins ? griffin ?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "griffin?") or string.find(string.lower(speech), "griffins?") or string.find(string.lower(speech), "griffins") or string.find(string.lower(speech), "griffin") or string.find(string.lower(speech), "griffins") or string.find(string.lower(speech), "?") or string.find(string.lower(speech), "griffin") or string.find(string.lower(speech), "?")) then
    return true  -- No matching keywords
end
self:command("peer " .. tostring(actor.name))
if actor.level < 45 then
    self.room:send(tostring(self.name) .. " says, 'Hehe, thanks for asking, but I really don't think you")
    self.room:send("</>can help " .. tostring(actor.name) .. ".")
    self:command("ruffle " .. tostring(actor.name))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'But find me a powerful hero and maybe the cult can be")
    self.room:send("</>stopped.'")
else
    self.room:send(tostring(self.name) .. " says, 'Yes, you may have noticed a lot of griffins around this")
    self.room:send("</>island, well their nature has brought an imbalance to this place, and our holy")
    self.room:send("</>mistletoe is dying.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'They distract my druids from tending to their trees")
    self.room:send("</>too.  We must stop the cult of griffin worshippers before it is too late.")
end