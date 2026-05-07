-- Trigger: heavens_gate_starlight_speech1
-- Zone: 133, ID: 30
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13330
--
-- Final ritual of the Heavens Gate quest. The actor must be at stage 4 and
-- speak the prayer "Hark ye starry angels and open the heavenly gates
-- before me" (case-insensitive, all keywords required). Grants the
-- "heavens gate" spell at full level, completes the quest, and the mob
-- destroys itself.
--
-- TODO(parity): the legacy DG script had probability 0%, which the
-- converter translated into a `percent_chance(0)` gate that would block
-- every fire. We've removed the synthetic gate; the trigger now fires on
-- any speech in the room and falls through unless every keyword in the
-- ritual phrase is present. Confirm the legacy intent (likely "scripted
-- only", not "never fire").

local required = { "hark", "ye", "starry", "angels", "and", "open",
                   "the", "heavenly", "gates", "before", "me" }
local speech_lower = string.lower(speech)
for _, word in ipairs(required) do
    if not string.find(speech_lower, word) then
        return true
    end
end

if actor:get_quest_stage("heavens_gate") ~= 4 then
    return true
end

wait(1)
self.room:send("<b:white>Starlight spreads wide across the cavern.</>")
self.room:send("<cyan>A <blue>tunnel of <white>light <cyan>opens up!</>")
wait(3)
actor:send("<b:white>From the reaches of the heavens some unknowable entity touches your soul.</>")
actor:send("<b:white>It imparts a prayer to you.</>")
skills.set_level(actor, "heavens gate", 100)
actor:complete_quest("heavens_gate")
actor:send("<b:cyan>You have learned <white>Heavens Gate<cyan>!</>")
wait(2)
self.room:send("<b:white>The starlight pours into the <b:cyan>tunnel <b:white>and is gone!</>")
world.destroy(self)

return true
