-- Trigger: painting-clue
-- Zone: 238, ID: 58
-- Type: WORLD, Flags: SPEECH
--
-- After greeting the painting (see 238:57), saying "yes/quest" while detect
-- magic is active reveals the dragons-and-sorcerer clue. Otherwise the
-- painting just rambles in arcane language.

-- Speech keywords: yes quest quest?
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "quest")) then
    return true  -- No matching keywords
end
if actor:has_effect(Effect.DetectMagic) then
    actor:send("The painting sighs. 'Yes, someone painted over the pentagram here.  Most unfortunate.  The clue read, \"The one who fought dragons stood to the right of the sorcerer\".'")
    wait(1)
    actor:send("The painting says, 'I hope you find that useful.'")
    actor:send("The painting goes back to studying the floor.")
    self.room:send_except(actor, "The painting speaks softly to " .. tostring(actor.name) .. ".")
else
    self.room:send("The painting speaks in a magical language.")
end
