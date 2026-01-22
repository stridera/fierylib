-- Trigger: quest_timulos_greet
-- Zone: 60, ID: 5
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #6005

-- Converted from DG Script #6005: quest_timulos_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local quest_name = actor:get_quest_var("merc_ass_thi_subclass:subclass_name")
-- switch on actor:get_quest_stage("merc_ass_thi_subclass")
if quest_name == "thief" then
    if actor:get_quest_stage("merc_ass_thi_subclass") == 1 then
        actor:send(tostring(self.name) .. " says, 'Back to try your hand at being a thief?  There is a <b:cyan>package</> that someone could get back.'")
    elseif quest_name == "mercenary" then
        actor:send(tostring(self.name) .. " says, 'If you want to continue training as a mercenary, listen up.  A <b:cyan>lord</> needs our services.'")
    elseif quest_name == "assassin" then
        actor:send(tostring(self.name) .. " says, 'Ah, you are back!  I believe I have a job for a trainee assassin.  One that would bring a good <b:cyan>price</>.'")
    end
    if quest_name == "thief" then
    elseif actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
        actor:send(tostring(self.name) .. " says, 'You getting cold feet about being a thief?  It's just stealing a package from some farmers.'")
        self:command("grumble")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Bloody <b:cyan>farmers</>.'")
    elseif quest_name == "mercenary" then
        actor:send(tostring(self.name) .. " says, 'Back to continue your mercenary training?  You're probably wondering about the <b:cyan>cloak</>.'")
    elseif quest_name == "assassin" then
        actor:send(tostring(self.name) .. " says, 'Stop wasting my time and finish your assassin training. I have some rich men unhappy with the politics of the region in question.  You could help with those <b:cyan>politics</> if you wish.'")
    end
    if quest_name == "thief" then
    elseif actor:get_quest_stage("merc_ass_thi_subclass") == 3 or actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
        actor:send(tostring(self.name) .. " says, 'Hurry up and finish your thief training.  Deliver the <b:yellow>package</> those Mielikki farmers walked off with!'")
    elseif quest_name == "mercenary" then
        actor:send(tostring(self.name) .. " says, 'Have you put your mercenary potential to good use?  Give me the <b:yellow>cloak</> the insect warriors stole.'")
    elseif quest_name == "assassin" then
        actor:send(tostring(self.name) .. " says, 'Is the job done?'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Shhhh, don't say anything!  Assassins keep their secrets.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'But do give me the target's <b:yellow>cane</> if you have it.'")
    end
else
    if actor:get_has_failed("merc_ass_thi_subclass") then
        actor:send(tostring(self.name) .. " says, 'That could have gone better.  I see you failed your mission.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I suppose you want to try again.'")
    elseif string.find(actor.class, "Rogue") and (actor.level >= 10 and actor.level <= 25) then
        actor:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", have you come to me for training?'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Well?  Do you want <b:cyan>training</> " .. tostring(actor.name) .. " or are you just going to stand there?'")
        self:command("tap")
    elseif string.find(actor.class, "Rogue") and actor.level < 10 then
        actor:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", have you come to me for trai- '")
        wait(2)
        self:emote("stops cold.")
        wait(1)
        self:command("eye " .. tostring(actor))
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You might be a bit green for my training, kid.'")
    end
end