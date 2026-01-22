-- Trigger: group_armor_forgemaster_speech
-- Zone: 590, ID: 45
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #59045

-- Converted from DG Script #59045: group_armor_forgemaster_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes yes! yep okay sure
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes!") or string.find(string.lower(speech), "yep") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "sure")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("group_armor")
wait(2)
if (string.find(actor.class, "Cleric") and actor.level > 72) or (string.find(actor.class, "Priest") and actor.level > 56) then
    if stage == 0 then
        actor.name:start_quest("group_armor")
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
        self.room:send(tostring(self.name) .. " says, 'Bring back a forging hammer and then I can tell")
        self.room:send("</>you what to do next.'")
    elseif stage == 3 or stage == 4 then
        self:say("Let me test out the new hammer then!")
    elseif stage == 6 then
        self:say("Let me see what you've brought!")
    end
elseif (string.find(actor.class, "Cleric") and actor.level < 72) or (string.find(actor.class, "Priest") and actor.level < 56) then
    self.room:send(tostring(self.name) .. " says, 'I don't think you're quite ready to be a forge")
    self.room:send("</>acolyte yet.'")
    self:command("laugh")
    actor:send(tostring(self.name) .. " claps you on the back with his mighty hand!")
    self.room:send_except(actor, tostring(self.name) .. " claps " .. tostring(actor.name) .. " on the back with his mighty hand.")
elseif actor.class ~= "Cleric" or actor.class ~= "Priest" then
    self.room:send(tostring(self.name) .. " says, 'You may wish to prove your worth but I can only")
    self.room:send("</>work with those dedicated to divinity.'")
end