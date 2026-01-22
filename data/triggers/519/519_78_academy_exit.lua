-- Trigger: academy exit
-- Zone: 519, ID: 78
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51978

-- Converted from DG Script #51978: academy exit
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: exit exit?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "exit") or string.find(string.lower(speech), "exit?")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    wait(2)
    self:command("nod " .. tostring(actor))
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  Come back any time.'")
    actor:teleport(get_room(30, 1))
    actor:send(tostring(self.name) .. " escorts you out of the Academy.")
    wait(2)
    get_room(30, 1):at(function()
        -- actor looks around
    end)
end