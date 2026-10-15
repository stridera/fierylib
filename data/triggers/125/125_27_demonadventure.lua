-- Trigger: DemonAdventure
-- Zone: 125, ID: 27
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12527

-- Converted from DG Script #12527: DemonAdventure
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"adventure", "explore", "exploration", "curiousity", "morning", "star"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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
    wait(0.2)
    self:say("BEGONE!")
end