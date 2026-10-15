-- Trigger: painting-clue
-- Zone: 238, ID: 58
-- Type: WORLD, Flags: SPEECH
--
-- After greeting the painting (see 238:57), saying "yes/quest" while detect
-- magic is active reveals the dragons-and-sorcerer clue. Otherwise the
-- painting just rambles in arcane language.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "quest", "quest?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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
