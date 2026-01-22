-- Trigger: academy_combat_speech_skip
-- Zone: 519, ID: 89
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51989

-- Converted from DG Script #51989: academy_combat_speech_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: skip
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "skip")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 3 then
    actor:set_quest_var("school", "fight", "complete")
    actor:advance_quest("school")
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  We'll skip combat and talk about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.")
    self.room:spawn_mobile(519, 0)
    combat.engage(self, self.room:find_actor("monster"))
    actor:send("<b:green>Say loot</> when you're ready to continue.'")
elseif actor:get_quest_stage("school") == 4 then
    actor:set_quest_var("school", "loot", "complete")
    actor:advance_quest("school")
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  You'll continue to the <b:green>east</>.'")
end