-- Trigger: eldest_speak2
-- Zone: 490, ID: 32
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49032

-- Converted from DG Script #49032: eldest_speak2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"griffin?", "griffins?", "griffins", "griffin", "griffins", "?", "griffin", "?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("peer " .. tostring(actor.name))
if actor.level < 45 then
    self.room:send(tostring(self.name) .. " says, 'Hehe, thanks for asking, but I really don't think you")
    self.room:send("</>can help " .. tostring(actor.name) .. ".")
    self:command("ruffle " .. tostring(actor.name))
    wait(0.1)
    self.room:send(tostring(self.name) .. " says, 'But find me a powerful hero and maybe the cult can be")
    self.room:send("</>stopped.'")
else
    self.room:send(tostring(self.name) .. " says, 'Yes, you may have noticed a lot of griffins around this")
    self.room:send("</>island, well their nature has brought an imbalance to this place, and our holy")
    self.room:send("</>mistletoe is dying.'")
    wait(0.1)
    self.room:send(tostring(self.name) .. " says, 'They distract my druids from tending to their trees")
    self.room:send("</>too.  We must stop the cult of griffin worshippers before it is too late.")
end