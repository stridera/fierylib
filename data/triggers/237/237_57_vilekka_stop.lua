-- Trigger: vilekka_stop
-- Zone: 237, ID: 57
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23757

-- Converted from DG Script #23757: vilekka_stop
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"stop"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- OK, here we have the other side of trigger 23754
-- where the player does not wish to continue the quest at this time
-- but they can come back later. :)
if (actor:get_quest_stage("vilekka_stew") == 2) and not (actor:get_quest_var("vilekka_stew:awarded_23718")) then
    self:command("nod")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'It is fine if you do not think you are yet worthy of more service.  Take this as a token of my appreciation.'")
    self.room:spawn_object(237, 18)
    self:command("give cloak " .. tostring(actor.name))
    actor:set_quest_var("vilekka_stew", "awarded_23718", 1)
    wait(1)
    self:emote("smiles fiercely.")
    self.room:send(tostring(self.name) .. " says, 'And should you ever wish to continue your service, just return to me.  Say you wish to continue, and I will give you more to do.'")
elseif (actor:get_quest_stage("vilekka_stew") == 4) and not (actor:get_quest_var("vilekka_stew:awarded_23717")) then
    self.room:spawn_object(237, 17)
    self:command("grin")
    self:say("I suppose I could let you off, this time...")
    wait(1)
    self:say("Wear this to show my thanks for your help.")
    self:command("give bracelet " .. tostring(actor.name))
    actor:set_quest_var("vilekka_stew", "awarded_23717", 1)
    self.room:send(tostring(self.name) .. " says, 'But do return and say that you wish to continue when you are more experienced.'")
end