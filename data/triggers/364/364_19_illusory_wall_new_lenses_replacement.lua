-- Trigger: illusory_wall_new_lenses_replacement
-- Zone: 364, ID: 19
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player who lost their magic spectacles says "I need new glasses" and Lyara
-- restarts the quest from stage 1 + clears all lens-component flags so they
-- can be re-collected. Legacy probability was 0% (a converter artefact).
--
-- Original DG Script: #36419

-- Speech keyword phrase: must contain "new glasses" to avoid false positives.
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "new glasses") then
    return true
end
if actor:get_quest_stage("illusory_wall") <= 1 then
    return true
end

wait(2)
self:say("That's unfortunate!  You'll have to make new ones.")
wait(2)
self:say("Bring me:")
self.room:send("- <b:yellow>A pair of glasses</> or <b:white>small spectacles</> to look through")
self.room:send("- <b:yellow>A prismatic leg spur</> to refract light properly")
self.room:send("- <b:yellow>A small piece of petrified magic</> to enhance the magical sight of the lenses")
wait(4)
self:say("Once you do, you can resume your studies.")
actor:restart_quest("illusory_wall")
actor:set_quest_var("illusory_wall", "103_7",  0)
actor:set_quest_var("illusory_wall", "185_11", 0)
actor:set_quest_var("illusory_wall", "410_5",  0)
actor:set_quest_var("illusory_wall", "510_17", 0)