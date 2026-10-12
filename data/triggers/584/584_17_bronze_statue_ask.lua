-- Trigger: Bronze_statue_ask
-- Zone: 584, ID: 17
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #58417

-- Converted from DG Script #58417: Bronze_statue_ask
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"gypsy", "prince", "task", "prize"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("major_spell_quest") ~= 4 then
    return true
end

wait(1)
self:emote("snorts flames from his nostrils!")
self:command("growl")
wait(2)
self:shout("What?! That backstabbing rogue wants his prize?!")
self:command("think")
wait(2)
self:say("Well that's just to bad, I guess I'll just dispatch you myself.")
actor:advance_quest("major_spell_quest")  -- advances to stage 5
wait(2)
combat.engage(actor)
self.room:spawn_object(520, 50)