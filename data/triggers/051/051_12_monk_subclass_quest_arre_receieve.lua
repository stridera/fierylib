-- Trigger: monk_subclass_quest_arre_receieve
-- Zone: 51, ID: 12
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5112

-- Converted from DG Script #5112: monk_subclass_quest_arre_receieve
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Receive trigger filtered to the bronze sash (object 16110 in legacy
-- vnum, no longer mapped here -- DG scoped this trigger to that object).
-- Stage gating:
--   1 / 2 - Quest not far enough along (player still owes the "fiend"
--           keyword); reject playfully.
--   3     - Player got the sash but didn't trigger the get hook (i.e.
--           handed off / stole it); refuse and call them out.
--   4     - Recover stage: complete the subclass quest.
--   else  - Stage 0/nil/5+: thank them, but no quest progress.
-- After all branches, junk the sash.
wait(2)
local stage = actor:get_quest_stage("monk_subclass")
if stage == 1 or stage == 2 then
    actor:send(self.name .. " says, 'Funny, I don't even remember telling you what you were questing for.'")
elseif stage == 3 then
    -- Player has the sash but never picked it up themselves.
    actor:send(self.name .. " says, 'How on earth did you get me this?  Did you come by it through your own means?'")
    self:command("eye " .. actor.name)
    self:emote("shakes her head.")
    wait(2)
    actor:send(self.name .. " says, 'I cannot help those who cheat themselves.'")
elseif stage == 4 then
    self:emote("cheers wildly, dancing all around the room.")
    wait(3)
    self:emote("pants heavily for a moment calming down.")
    wait(1)
    self:command("shake " .. actor.name)
    actor:send(self.name .. " says, 'Wonderful, this shows your true dedication to helping one of the brotherhood.'")
    self:command("grin")
    wait(2)
    actor:send(self.name .. " says, 'Type &9<blue>'subclass'</> to proceed.'")
    actor:complete_quest("monk_subclass")
else
    actor:send(self.name .. " says, 'What a wonderful sash, thank you.'")
    wait(1)
    actor:send(self.name .. " says, 'Shame you were not questing for me, this is a great prize you have given me.'")
end
self:destroy_item("sash")