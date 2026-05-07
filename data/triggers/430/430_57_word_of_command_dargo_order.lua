-- Trigger: word_of_command_dargo_order
-- Zone: 430, ID: 57
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #43057

-- Converted from DG Script #43057: word_of_command_dargo_order
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: order
if not (cmd == "order") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if string.find(arg, "enter door") then
    if actor:get_quest_stage("word_command") == 3 then
        if self.room.zone_id == 430 and self.room.local_id == 176 then
            self:command("enter door")
        else
            self.room:send(tostring(self.name) .. " looks frantically for a door and panics!")
        end
    elseif actor:get_quest_stage("word_command") then
        self:say("I'm not free from the curse yet!")
    end
end
return _return_value