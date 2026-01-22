-- Trigger: academy_revel_command_help
-- Zone: 519, ID: 66
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51966

-- Converted from DG Script #51966: academy_revel_command_help
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: help
if not (cmd == "help") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:rest") == 7 then
    -- switch on arg
    if arg == "zo" or arg == "zon" or arg == "zone" then
        actor:set_quest_var("school", "rest", "complete")
        actor:command("help zone")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'When you're ready to stop playing, to safely log out, you have to find an inn.")
        actor:send("Talk to the inn's receptionist and <b:cyan>RENT</> a room.")
        actor:send("Think of inns like save points.")
        actor:send("Renting stores all your items for free.")
        actor:send("When you log back in, you'll be at the inn.'")
        wait(1)
    end
end
if actor:get_quest_stage("school") == 5 then
    if actor:get_quest_var("school:money") == "complete" and actor:get_quest_var("school:rest") == "complete" then
        actor:advance_quest("school")
        actor:send(tostring(self.name) .. " tells you, 'You're ready to graduate from Ethilien Academy!")
        actor:send("<b:green>Say finish</> to end the school.'")
    else
        actor:send(tostring(self.name) .. " tells you, '<b:green>Say money</> to finish your last lesson, or say <magenta>SKIP</> to jump to the end of the Academy.'")
    end
end
_return_value = false
return _return_value