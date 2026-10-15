-- Trigger: thief_subclass_timulos_receive
-- Zone: 60, ID: 23
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #6023

-- Converted from DG Script #6023: thief_subclass_timulos_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (8813): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 88 and object.id == 13)
) then
    return true
end

wait(0.2)
-- switch on actor:get_quest_stage("merc_ass_thi_subclass")
if actor:get_quest_stage("merc_ass_thi_subclass") == 1 or actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Interesting, I have not even told you what to do yet...  So how did you do it?'")
elseif actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'How ever did you get what I ask for without getting it yourself?'")
    self:command("spank " .. tostring(actor.name))
    -- TODO(parity): converter dropped the package-id check here; preserved
    -- subclass-name guard so the reward path executes for thieves on stage 3.
    if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" then
        actor:send(tostring(self.name) .. " says, 'Wonderful, now I can return this to its rightful owner.'")
        wait(0.2)
        self:emote("mutters something about how a true thief would try to take it back.")
        self:emote("clears his throat and says, 'You have done well, congratulations!'")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Type '<b:red>subclass</>' to proceed.'")
        actor:complete_quest("merc_ass_thi_subclass")
    end
else
    actor:send(tostring(self.name) .. " says, 'Well this is nifty, I think I will hold on to that, thank you.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Shame you were not on a quest for me.'")
end
self:destroy_item("questobject")