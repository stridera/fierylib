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
if actor:get_quest_stage("school") < 5 then
    actor:send(tostring(self.name) .. " tells you, 'You're not quite ready to move on yet!'")
else
    actor:move("e")
end