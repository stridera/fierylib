-- Trigger: group_armor_forgemaster_speech
-- Zone: 590, ID: 45
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #59045

-- Converted from DG Script #59045: group_armor_forgemaster_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "yes!", "yep", "okay", "sure"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local stage = actor:get_quest_stage("group_armor")
wait(0.2)
if (string.find(actor.class, "cleric") and actor.level > 72) or (string.find(actor.class, "priest") and actor.level > 56) then
    if stage == 0 then
        actor:start_quest("group_armor")
        self:say("Then welcome aboard!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'First, I need four things that cast the Armor")
        self.room:send("</>spell to amplify my prayers to Moradin:'")
        self.room:send("<b:yellow>" .. tostring(objects.template(61, 18).name) .. "</>")
        self.room:send("<b:yellow>" .. tostring(objects.template(117, 4).name) .. "</>")
        self.room:send("<b:yellow>" .. tostring(objects.template(117, 7).name) .. "</>")
        self.room:send("<b:yellow>" .. tostring(objects.template(169, 6).name) .. "</>")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Moradin watch over your travels!")
        self.room:send("</>If you need an update, ask me about your <b:white>[progress]</>.'")
    elseif stage == 1 then
        self:say("Let me see what you have!")
    elseif stage == 2 then
        self:say("Thank you so much!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Bring back a forging hammer then I can tell")
        self.room:send("</>you what to do next.'")
    elseif stage == 3 or stage == 4 then
        self:say("Let me test out the new hammer then!")
    elseif stage == 6 then
        self:say("Let me see what you've brought!")
    end
elseif (string.find(actor.class, "cleric") and actor.level < 72) or (string.find(actor.class, "priest") and actor.level < 56) then
    self.room:send(tostring(self.name) .. " says, 'I don't think you're quite ready to be a forge")
    self.room:send("</>acolyte yet.'")
    self:command("laugh")
    actor:send(tostring(self.name) .. " claps you on the back with his mighty hand!")
    self.room:send_except(actor, tostring(self.name) .. " claps " .. tostring(actor.name) .. " on the back with his mighty hand.")
elseif actor.class ~= "cleric" or actor.class ~= "priest" then
    self.room:send(tostring(self.name) .. " says, 'You may wish to prove your worth but I can only")
    self.room:send("</>work with those dedicated to divinity.'")
end