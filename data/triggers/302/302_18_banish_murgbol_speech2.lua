-- Trigger: banish_murgbol_speech2
-- Zone: 302, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   TODO: Verify `skills.set_level(actor.name, ...)` API — may need actor itself
--   rather than name. Verify `actor:complete_quest("banish")` exists in runtime.
--
-- Original DG Script: #30218

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"vibugp"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("banish") == 7 then
    actor:send(tostring(self.name) .. " chants along with you.")
    self.room:send_except(actor, tostring(self.name) .. " chants along with " .. tostring(actor.name) .. ".")
    self.room:send(tostring(self.name) .. " starts casting, <b:yellow>'Vibugp'</>...")
    wait(2)
    actor:send("There is a bright flash as you feel the power of the spell well up in the words, <b:red>'I banish thee!'</>")
    skills.set_level(actor, "banish", 1000)
    wait(1)
    actor:send("<b:red>You have mastered the prayer for Banish!</>")
    actor:complete_quest("banish")
    if not actor:get_quest_var("hell_trident:helltask5") and actor:get_quest_stage("hell_trident") == 1 then
        actor:set_quest_var("hell_trident", "helltask5", 1)
    end
    self.room:send_except(actor, "There is a bright flash as the spell goes off!")
    self.room:send_except(actor, tostring(actor.name) .. " seems to be more connected to the universe!")
end