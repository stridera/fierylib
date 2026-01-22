-- Trigger: monk_subclass_quest_arre_receieve
-- Zone: 51, ID: 12
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5112

-- Converted from DG Script #5112: monk_subclass_quest_arre_receieve
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("monk_subclass")
if actor:get_quest_stage("monk_subclass") == 1 or actor:get_quest_stage("monk_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Funny, I don't even remember telling you what you were questing for.'")
elseif actor:get_quest_stage("monk_subclass") == 3 then
    -- got sash without getting sash themselves
    actor:send(tostring(self.name) .. " says, 'How on earth did you get me this?  Did you come by it through your own means?'")
    self:command("eye " .. tostring(actor.name))
    self:emote("shakes her head.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I cannot help those who cheat themselves.'")
elseif actor:get_quest_stage("monk_subclass") == 4 then
    self:emote("cheers wildly, dancing all around the room.")
    wait(3)
    self:emote("pants heavily for a moment calming down.")
    wait(1)
    self:command("shake " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Wonderful, this shows your true dedication to helping one of the brotherhood.'")
    self:command("grin")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Type &9<blue>'subclass'</> to proceed.'")
    actor.name:complete_quest("monk_subclass")
else
    actor:send(tostring(self.name) .. " says, 'What a wonderful sash, thank you.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Shame you were not questing for me, this is a great prize you have given me.'")
end
self:destroy_item("sash")