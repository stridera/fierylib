-- Trigger: quest_timulos_merc_cloak
-- Zone: 60, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6014

-- Converted from DG Script #6014: quest_timulos_merc_cloak
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"cloak"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "mercenary" and actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
    actor:advance_quest("merc_ass_thi_subclass")
    actor:send(tostring(self.name) .. " says, 'Well yes, this cloak is worth much to him.'")
    wait(0.1)
    actor:send(tostring(self.name) .. " says, 'It was made off with in a raid on his castle by some bothersome insect warriors.'")
    self:command("mutter")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'All the Lord was able to tell me is they said something about wanting it for their queen.'")
    self:command("shrug")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I think you should go find it now.  Come back when you have the <b:yellow>cloak</>, do not come back at all.'")
    self:command("open fence")
    self:emote("pushes " .. tostring(actor.name) .. " away.")
    actor:move("north")
    self:command("close fence")
end