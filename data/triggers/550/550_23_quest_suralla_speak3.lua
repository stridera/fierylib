-- Trigger: quest_suralla_speak3
-- Zone: 550, ID: 23
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55023

-- Converted from DG Script #55023: quest_suralla_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"suffering", "suffer", "battled", "still", "what"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("cryomancer_subclass") == 2 then
    wait(1)
    self:emote("smiles sadly.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It is a shame really, that poor shrub, it really was an innocent in all of that.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I do feel bad about it.  The poor thing tried to flee us and sought the shaman who created him.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I do not know if that will help you end his suffering or not, but I hope it does.'")
    wait(2)
    self:command("grin")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'And the reward will be great if you do.  The shrub muttered something about a place with rushing water and some odd warriors being his safety.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Oh!  One last thing.  When you return to claim your reward, be sure to say to me <b:cyan>\"the shrub suffers no longer\"</>, and the prize will be yours.'")
    wait(2)
    self:command("smile")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Go about it now.'")
    actor:advance_quest("cryomancer_subclass")
end