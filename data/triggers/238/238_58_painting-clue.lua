-- Trigger: painting-clue
-- Zone: 238, ID: 58
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23858

-- Converted from DG Script #23858: painting-clue
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes quest quest?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "quest?")) then
    return true  -- No matching keywords
end
if actor:has_effect(Effect.DetectMagic) == "TRUE" then
    actor:send("The painting sighs. 'Yes, someone painted over the pentagram here.  Most unfortunate.  The clue read, \"The one who fought dragons stood to the right of the sorcerer\".'")
    wait(1)
    actor:send("The painting says, 'I hope you find that useful.'")
    actor:send("The painting goes back to studying the floor.")
    self.room:send_except(actor, "The painting speaks softly to " .. tostring(actor.name) .. ".")
else
    self.room:send("The painting speaks in a magical language.")
end