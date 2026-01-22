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
if not (string.find(string.lower(speech), "adventure") or string.find(string.lower(speech), "explore") or string.find(string.lower(speech), "exploration") or string.find(string.lower(speech), "curiousity") or string.find(string.lower(speech), "morning") or string.find(string.lower(speech), "star")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("krisenna_quest") == 3 then
    actor.name:advance_quest("krisenna_quest")
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