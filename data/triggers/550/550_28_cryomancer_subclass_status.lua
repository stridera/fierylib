-- Trigger: cryomancer_subclass_status
-- Zone: 550, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #55028

-- Converted from DG Script #55028: cryomancer_subclass_status
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: subclass progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "subclass") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
-- switch on actor:get_quest_stage("cryomancer_subclass")
if actor:get_quest_stage("cryomancer_subclass") == 1 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It will take a great mage with a dedication to the cold arts to complete the <b:cyan>quest</> I lay before you.  Your reward is simple if you succeed, and I am sure you will enjoy a life of the cold.'")
elseif actor:get_quest_stage("cryomancer_subclass") == 2 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It is quite simple.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'My counterpart, the great Emmath Firehand, long ago battled with me once.'")
    self:emote("reminisces for a brief moment, looking thoughtful.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It was not serious by any means, but it did end in a stalemate.  The catch however...'")
    self:command("sigh")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Is that what we battled over may still be <b:cyan>suffering</>.'")
    self:emote("sighs deeply again.")
elseif actor:get_quest_stage("cryomancer_subclass") == 3 then
    wait(2)
    self:emote("smiles sadly.")
    actor:send(tostring(self.name) .. " says, 'It is a shame really, that poor shrub, it really was an innocent in all of that.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I do feel bad about it.  The poor thing tried to flee us and sought the shaman who created him.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I do not know if that will help you end his suffering or not, but I hope it does.'")
    self:command("grin")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'And the reward will be great if you do.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'The shrub muttered something about a place with rushing water and some odd warriors being his safety.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Oh!  One last thing.  When you return to claim your reward, be sure to say to me <b:cyan>\"The shrub suffers no longer\"</>, and the prize will be yours.'")
    self:command("smile")
    actor:send(tostring(self.name) .. " says, 'Go about it now.")
elseif actor:get_quest_stage("cryomancer_subclass") == 4 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Say <b:cyan>\"The shrub suffers no longer\"</>, and the prize will be yours.'")
else
    if string.find(actor.class, "Sorcerer") then
        -- switch on actor.race
        if actor.level >= 10 and actor.level <= 45 then
            if actor.race == "dragonborn_fire" or actor.race == "arborean" then
                actor:send("<red>Your race cannot subclass to cryomancer.</>")
            end
        else
            wait(2)
            if actor.level >= 10 and actor.level <= 45 then
                actor:send(tostring(self.name) .. " says, 'You are not yet on my quest.'")
            elseif actor.level < 10 then
                actor:send(tostring(self.name) .. " says, 'Come back to me once you've gained more experience.'")
            elseif string.find(actor.class, "Sorcerer") and actor.level > 45 then
                actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
            end
        end
    end
end  -- auto-close block