-- Trigger: quest_eleweiss_ranger_druid_subclass_receive
-- Zone: 163, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16308

-- Converted from DG Script #16308: quest_eleweiss_ranger_druid_subclass_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
if actor:get_quest_stage("ran_dru_subclass") == 4 then
    self:emote("throws back his head and howls loudly with pleasure.")
    wait(3)
    self:command("shake " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'You have done me a great service!  I cannot believe I have it back!'")
    self:command("grin")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Type <b:green>'subclass'</> to proceed.'")
    actor.name:complete_quest("ran_dru_subclass")
else
    -- switch on actor:get_quest_stage("ran_dru_subclass")
    if actor:get_quest_stage("ran_dru_subclass") == 1 or actor:get_quest_stage("ran_dru_subclass") == 2 then
        actor:send(tostring(self.name) .. " says, 'Woah, slow down, I have not even told you the quest yet!'")
    elseif actor:get_quest_stage("ran_dru_subclass") == 3 then
        actor:send(tostring(self.name) .. " says, 'How on earth did you bring me the jewel of the heart without getting it yourself?'")
        self:command("chuckle")
    else
        actor:send(tostring(self.name) .. " says, 'Nice little gift, thanks much.'")
        self:emote("tucks it into his cloak.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Pity you were not on a quest for me, this could have been worth it for you.'")
    end
end
self:destroy_item("jewel")