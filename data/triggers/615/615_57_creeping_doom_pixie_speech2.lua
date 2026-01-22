-- Trigger: creeping_doom_pixie_speech2
-- Zone: 615, ID: 57
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61557

-- Converted from DG Script #61557: creeping_doom_pixie_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: vengeance revenge avenger vessel? Abuses? vengeance? revenge? avenger? vessel abuses
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "vengeance") or string.find(string.lower(speech), "revenge") or string.find(string.lower(speech), "avenger") or string.find(string.lower(speech), "vessel?") or string.find(string.lower(speech), "abuses?") or string.find(string.lower(speech), "vengeance?") or string.find(string.lower(speech), "revenge?") or string.find(string.lower(speech), "avenger?") or string.find(string.lower(speech), "vessel") or string.find(string.lower(speech), "abuses")) then
    return true  -- No matching keywords
end
wait(2)
self.room:send(tostring(self.name) .. " says, 'Yes, we need a powerful priest of Nature to be our")
self.room:send("</>avenging avatar!'")
wait(2)
if string.find(actor.class, "Druid") then
    if actor.level > 80 then
        self:say("Will you be our vessel?")
    else
        self:say("Come back after your power has grown some more.")
    end
end