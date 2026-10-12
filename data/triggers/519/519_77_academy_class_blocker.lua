-- Trigger: academy_class_blocker
-- Zone: 519, ID: 77
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51977

-- Converted from DG Script #51977: academy_class_blocker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local stage = actor:get_quest_stage("school")
if stage < 5 then
    actor:send(tostring(self.name) .. " tells you, 'You're not quite ready to move on yet!'")
    -- Say what to do about it (the original gave no hint).
    if stage == 3 then
        actor:send(tostring(self.name) .. " tells you, 'Finish the combat lessons here first, or say <magenta>SKIP</> to move on to <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.  You can also say <magenta>EXIT</> to leave the Academy.'")
    elseif stage == 4 then
        actor:send(tostring(self.name) .. " tells you, 'Finish the <b:yellow>LOOT</> and <b:yellow>TOGGLES</> lessons first, or say <magenta>SKIP</> to move on.  You can also say <magenta>EXIT</> to leave the Academy.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Say <magenta>EXIT</> to leave the Academy, or go back and finish your earlier lessons.'")
    end
else
    actor:move("e")
end