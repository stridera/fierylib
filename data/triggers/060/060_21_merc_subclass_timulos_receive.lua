-- Trigger: merc_subclass_timulos_receive
-- Zone: 60, ID: 21
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #6021

-- Converted from DG Script #6021: merc_subclass_timulos_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("merc_ass_thi_subclass")
if actor:get_quest_stage("merc_ass_thi_subclass") == 1 or actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Interesting, I have not even told you what to do yet...  So how did you do it?'")
elseif actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'How ever did you get what I ask for without getting it yourself?'")
    self:command("spank " .. tostring(actor.name))
    if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "mercenary" then
    elseif actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
        self:emote("grins from ear to ear.")
        actor:send(tostring(self.name) .. " says, 'You have done me a great service.  The lord will reward me kindly to get this back.'")
        self:command("flex")
        self:emote("shouts, 'Yes, yes, yes!!!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Type '<yellow>subclass</>' to proceed.'")
        actor.name:complete_quest("merc_ass_thi_subclass")
    end
else
    actor:send(tostring(self.name) .. " says, 'Well this is nifty, I think I will hold on to that, thank you.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Shame you were not on a quest for me.'")
end
self:destroy_item("questobject")