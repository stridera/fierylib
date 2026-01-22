-- Trigger: give_head_ziijhan
-- Zone: 85, ID: 6
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #8506

-- Converted from DG Script #8506: give_head_ziijhan
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("nec_dia_ant_subclass")
if actor:get_quest_stage("nec_dia_ant_subclass") == 1 or actor:get_quest_stage("nec_dia_ant_subclass") == 2 then
    -- not in final stage of quest
    actor:send(tostring(self.name) .. " says, 'Hmmm, jumping the gun a bit aren't we?  I didn't even tell you the quest yet.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Thanks for the gift, weirdo.'")
elseif actor:get_quest_stage("nec_dia_ant_subclass") == 3 then
    -- somehow they have the head without GETTING it
    actor:send(tostring(self.name) .. " says, 'Hmmm, how did you get this head without GETTING it?'")
    self:command("whap " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I can't abide that sort of foolishness!'")
elseif actor:get_quest_stage("nec_dia_ant_subclass") == 4 then
    self:emote("throws back his head and howls devilishly with pleasure.")
    wait(3)
    self:command("shake " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'You have done me a great service, and earned your place among the truly dark.")
    self:command("smi")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Type <red>'subclass'</> to proceed.'")
    actor.name:complete_quest("nec_dia_ant_subclass")
else
    actor:send(tostring(self.name) .. " says, 'Well, what a lovely gift, I must stuff it and mount it on my wall.'")
    self:command("thank " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Shame you weren't performing the quest, you seem to be a nasty piece of work.'")
end
-- junk the head
self:destroy_item("head")