-- Trigger: lp_box
-- Zone: 43, ID: 52
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4352

-- Converted from DG Script #4352: lp_box
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: place?  Where?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "place?") or string.find(string.lower(speech), "where?")) then
    return true  -- No matching keywords
end
wait(2)
actor:send("With a deft motion, the Leading Player places himself behind you, whispering in your ear.")
self.room:send_except(actor, "With a deft motion, the Leading Player places himself behind " .. tostring(actor.name) .. ".")
wait(2)
self.room:send(tostring(self.name) .. " says, 'Our great Fire Box!  It is the piece de resistance.")
self.room:send("And it is ready for the person we have picked to perform our Finale.'")
wait(4)
actor:send("The Leading Player softly caresses your face, his lips inches from your ear.")
self.room:send_except(actor, "The Leading Player softly caresses " .. tostring(actor.name) .. "'s face.")
wait(2)
self:say("If YOU want to be that person, you may try.")
wait(4)
self:emote("waves his hand in front of an invisible point in space.")
self:say("Think about the sun; join in one perfect flame.")
wait(4)
actor:send("With a powerful thrust, the Leading Player presses himself up very close to you.")
self.room:send_except(actor, "With a powerful thrust, the Leading Player presses himself up very close to " .. tostring(actor.name) .. ".")
wait(3)
self.room:send(tostring(self.name) .. " says, 'Become one with the flame - and in that flame become")
self.room:send("</>a glorious synthesis of life and death, and life again.'")
wait(3)
self:emote("releases his embrace, breaking free into a powerful pose.")
wait(4)
self:say("Think about the sun.")
wait(2)
self.room:send(tostring(self.name) .. " says, 'Unfortunately we can't get this show on the road")
self.room:send("</>until the theatre is reorganized after that monkey attack.'")
wait(3)
self:say("Talk to the House Gnome King.")