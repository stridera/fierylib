-- Trigger: DemonAdventure
-- Zone: 125, ID: 27
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12527

-- Converted from DG Script #12527: DemonAdventure
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: adventure explore exploration curiousity morning star
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "adventure") or string.find(speech_lower, "explore") or string.find(speech_lower, "exploration") or string.find(speech_lower, "curiousity") or string.find(speech_lower, "morning") or string.find(speech_lower, "star")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("krisenna_quest") == 3 then
    actor:advance_quest("krisenna_quest")
    wait(1)
    self:say("Such curiosity can be quite dangerous.  Very well.")
    wait(2)
    self:say("My morning star would be quite a trophy of your exploits...")
    wait(2)
    self:emote("stops using Krisenna's morning-star.")
    self.room:spawn_object(125, 45)
    self:command("drop star")
    self:say("Now...")
    wait(2)
    self:say("BEGONE!")
end