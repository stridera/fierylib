-- Trigger: LP2_bard_subclass_command_sing
-- Zone: 43, ID: 57
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4357

-- Converted from DG Script #4357: LP2_bard_subclass_command_sing
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: sing
if not (cmd == "sing") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "si" then
    _return_value = false
    return _return_value
end
actor:command("sing")
if actor:get_quest_stage("bard_subclass") == 1 then
    actor:advance_quest("bard_subclass")
    wait(3)
    self:emote("blinks very slowly.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Okay, not the best I've ever heard but not the worst either.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Maybe your <b:magenta>dance</> skills are better.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Show me what ya got!'")
end
return _return_value