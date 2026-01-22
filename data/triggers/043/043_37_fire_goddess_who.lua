-- Trigger: fire_goddess_who
-- Zone: 43, ID: 37
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4337

-- Converted from DG Script #4337: fire_goddess_who
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: who? he? him?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "who?") or string.find(string.lower(speech), "he?") or string.find(string.lower(speech), "him?")) then
    return true  -- No matching keywords
end
wait(2)
self.room:send(tostring(self.name) .. " says, 'Pippin of course!  He's our star of this production.")
self.room:send("</> He's the last thing we need for our grand finale.'")
wait(2)
self.room:send(tostring(self.name) .. " says, 'Of course we can't find him, what with the monkey")
self.room:send("</>invasion earlier.  All of our props and costumes got all messed up, and now our")
self.room:send("</>star has gone missing too!'")
wait(3)
self:say("Talk to the House Gnome King and see about getting that straightened out.")