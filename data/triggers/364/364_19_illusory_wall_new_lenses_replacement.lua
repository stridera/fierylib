-- Trigger: illusory_wall_new_lenses_replacement
-- Zone: 364, ID: 19
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #36419

-- Converted from DG Script #36419: illusory_wall_new_lenses_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need new glasses
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "glasses")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("illusory_wall") > 1 then
    self:say("That's unfortunate!  You'll have to make new ones.")
    wait(2)
    self:say("Bring me:")
    self.room:send("- <b:yellow>A pair of glasses</> or <b:white>small spectacles</> to look through")
    self.room:send("- <b:yellow>A prismatic leg spur</> to refract light properly")
    self.room:send("- <b:yellow>A small piece of petrified magic</> to enhance the magical sight of the lenses")
    wait(4)
    self:say("Once you do, you can resume your studies.")
    actor.name:restart_quest("illusory_wall")
    actor.name:set_quest_var("illusory_wall", "10307", 0)
    actor.name:set_quest_var("illusory_wall", "18511", 0)
    actor.name:set_quest_var("illusory_wall", "41005", 0)
    actor.name:set_quest_var("illusory_wall", "51017", 0)
end