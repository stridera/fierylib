-- Trigger: crowley_speak1
-- Zone: 490, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49017

-- Converted from DG Script #49017: crowley_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: forget?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "forget?")) then
    return true  -- No matching keywords
end
wait(4)
self.room:send(tostring(self.name) .. " says, 'I drink to forget until I forget to drink.  The chapel")
self.room:send("</>was the most horrible place I have ever seen.  The sight of it is burned into")
self.room:send("</>my mind.'")
wait(2)
actor.name:send(tostring(self.name) .. " falls to the ground before you.")
self.room:send_except(actor.name, tostring(self.name) .. " falls to the ground before " .. tostring(actor.name) .. ".")
self:say("I beg you to destroy that place utterly.")
wait(3)
self.room:send(tostring(self.name) .. " stands and dusts off his clothes.")
self:say("May the tree spirits guard you.")