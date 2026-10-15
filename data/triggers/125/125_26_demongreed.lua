-- Trigger: DemonGreed
-- Zone: 125, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12526

-- Converted from DG Script #12526: DemonGreed
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"greed", "money", "pouch", "wergeld", "wergild"}) do
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
    self:say("Ahh yes, the sin of sins.  Very well, I will give you my coins.")
    wait(2)
    self:say("But, you must promise to not let others know about us.")
    wait(1)
    self:say("Saving ourselves the trouble would be worth it.")
    wait(2)
    self:emote("stops using a pouch full of money.")
    self.room:spawn_object(125, 44)
    self:command("drop pouch")
    self:say("Now...")
    wait(0.2)
    self:say("BEGONE!")
end