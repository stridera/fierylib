-- Trigger: academy_clerk_command_score
-- Zone: 519, ID: 24
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51924

-- Converted from DG Script #51924: academy_clerk_command_score
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: score
if not (cmd == "score") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("school") == 2 then
    if actor:get_quest_var("school:score") == 1 then
        actor:set_quest_var("school", "score", "complete")
        actor:command("score")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Yep, just like that.  That great big bar at the")
        actor:send("</>bottom is your experience bar.  That will fill as you kill stuff.  When it")
        actor:send("</>reaches full, you'll be ready to level!'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Are you ready to continue?")
        actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
    end
end
_return_value = false
return _return_value