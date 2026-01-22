-- Trigger: banish_murgbol_speech2
-- Zone: 302, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #30218

-- Converted from DG Script #30218: banish_murgbol_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: vibugp
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "vibugp")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("banish") == 7 then
    actor:send(tostring(self.name) .. " chants along with you.")
    self.room:send_except(actor, tostring(self.name) .. " chants along with " .. tostring(actor.name) .. ".")
    self.room:send(tostring(self.name) .. " starts casting, <b:yellow>'Vibugp'</>...")
    wait(2)
    actor:send("There is a bright flash as you feel the power of the spell well up in the words, <b:red>'I banish thee!'</>")
    skills.set_level(actor.name, "banish", 100)
    wait(1)
    actor:send("<b:red>You have mastered the prayer for Banish!</>")
    actor.name:complete_quest("banish")
    if not actor:get_quest_var("hell_trident:helltask5") and actor:get_quest_stage("hell_trident") == 1 then
        actor:set_quest_var("hell_trident", "helltask5", 1)
    end
    self.room:send_except(actor, "There is a bright flash as the spell goes off!")
    self.room:send_except(actor, tostring(actor.name) .. " seems to be more connected to the universe!")
end