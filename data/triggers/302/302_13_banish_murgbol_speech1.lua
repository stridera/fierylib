-- Trigger: banish_murgbol_speech1
-- Zone: 302, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #30213

-- Converted from DG Script #30213: banish_murgbol_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes yes? sure yep okay yeah cool good
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes?") or string.find(string.lower(speech), "sure") or string.find(string.lower(speech), "yep") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "yeah") or string.find(string.lower(speech), "cool") or string.find(string.lower(speech), "good")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("banish")
if string.find(actor.class, "priest") or string.find(actor.class, "diabolist") then
    if stage == 0 then
        if actor.level > 64 then
            self:say("Good, good...")
            actor.name:start_quest("banish")
            wait(1)
            self:say("I shall see how the gods best wish me to teach you.")
            self.room:send("She closes her eyes and prays to the gods above and below.")
            wait(7)
            self:say("The gods have decreed you must go on a vision quest.")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'They demand you demonstrate power over the six animating forces.")
            self.room:send("</>After each demonstration, they'll provide you with a different part of the")
            self.room:send("</>spell to banish your foes.  <b:cyan>Record those visions</> - they're critical to")
            self.room:send("</>unlocking the spell.'")
            wait(7)
            self.room:send(tostring(self.name) .. " says, 'Your first vision will be granted when you prove mastery over")
            self.room:send("</>magical life.  Find the <blue>mighty witch of the sea</> in her lair beneath the waves")
            self.room:send("</>and defeat her.  The gods will give you part of the prayer.'")
            wait(6)
            self:say("Return to me after and I will guide you to your next act.")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'And if you need a reminder, check in with me on your <b:white>[progress]</>")
            self.room:send("</>any time you feel like it.'")
            wait(2)
            self:say("Now go!")
            actor:set_quest_var("banish", "greet", 1)
        else
            self:say("Give it time kid.  You aren't ready to wield such power.")
        end
    end
end