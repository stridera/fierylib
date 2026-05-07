-- Trigger: quest_eleweiss_ranger_druid_subclass_speak1
-- Zone: 163, ID: 2
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #16302
--
-- Player asks Eleweiss about "ways" (of the woods). Class- and alignment-gated
-- offer of the ranger or druid subclass. Sets globals.use_subclass to "Ran"
-- or "Dru" so the yes/no follow-up (speak2) knows what was offered.

if not (string.find(speech, "ways") or string.find(speech, "I know")) then
    return true
end

if actor:get_quest_stage("ran_dru_subclass") then
    return true
end

-- TODO(parity): legacy DG had a race switch ("ADD NEW RESTRICTED RACES HERE")
-- that halted on disallowed races before each class block.

if string.find(actor.class, "Cleric") then
    wait(2)
    if actor.level >= 10 and actor.level <= 35 then
        if globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'I'm currently assisting someone else, one moment please.'")
            return true
        end
        if actor.alignment > -350 and actor.alignment < 350 then
            self:command("smile " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Do you wish to join the ranks of the woodland healers with all the power there of?'")
            globals.use_subclass = "Dru"
        else
            actor:send(tostring(self.name) .. " says, 'You are not properly aligned to be a woodland cleric.  Come back when you fix that.'")
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
    end
elseif string.find(actor.class, "Warrior") then
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        if globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'I'm currently assisting someone else, one moment please.'")
            return true
        end
        if actor.alignment > 349 then
            self:command("nod " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Do you wish to become a fighter who is one with the forests?'")
            globals.use_subclass = "Ran"
        else
            actor:send(tostring(self.name) .. " says, 'Sorry, your alignment is not proper for what you wish to be.  Try again later.'")
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Seek me again later when you have gained some more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
    end
else
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I can do nothing for you, I am sorry.'")
    self:emote("smiles a little bit.")
end
