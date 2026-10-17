-- Trigger: academy_combat_speech_skip
-- Zone: 519, ID: 89
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51989

-- Converted from DG Script #51989: academy_combat_speech_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"skip"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 3 then
    actor:set_quest_var("school", "fight", "complete")
    actor:advance_quest("school")
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  We'll skip combat and talk about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.")
    self.room:spawn_mobile(519, 0)
    combat.engage(self, self.room:find_actor("monster"))
    actor:send("<b:green>Say loot</> when you're ready to continue.")
elseif actor:get_quest_stage("school") == 4 then
    actor:set_quest_var("school", "loot", "complete")
    actor:advance_quest("school")
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  You'll continue to the <b:green>east</>.'")
end