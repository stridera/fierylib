-- Trigger: heavens_gate_starlight_speech1
-- Zone: 133, ID: 30
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13330

-- Converted from DG Script #13330: heavens_gate_starlight_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: Hark ye starry angels and open the heavenly gates before me
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hark") or string.find(string.lower(speech), "ye") or string.find(string.lower(speech), "starry") or string.find(string.lower(speech), "angels") or string.find(string.lower(speech), "and") or string.find(string.lower(speech), "open") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "heavenly") or string.find(string.lower(speech), "gates") or string.find(string.lower(speech), "before") or string.find(string.lower(speech), "me")) then
    return true  -- No matching keywords
end
if %actor.quest_stage[heavens_gate] == 4 then
    wait(1)
    self.room:send("<b:white>Starlight spreads wide across the cavern.</>")
    self.room:send("<cyan>A <blue>tunnel of <white>light <cyan>opens up!</>")
    wait(3)
    actor:send("<b:white>From the reaches of the heavens some unknowable entity touches your soul.</>")
    actor:send("<b:white>It imparts a prayer to you.</>")
    -- (empty send to actor)
    skills.set_level(actor.name, "heavens gate", 100)
    actor.name:complete_quest("heavens_gate")
    actor:send("<b:cyan>You have learned <white>Heavens Gate<cyan>!</>")
    wait(2)
    self.room:send("<b:white>The starlight pours into the <b:cyan>tunnel <b:white>and is gone!</>")
    world.destroy(self)
end