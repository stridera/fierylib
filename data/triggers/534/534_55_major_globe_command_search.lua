-- Trigger: major_globe_command_search
-- Zone: 534, ID: 55
-- Type: WORLD, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #53455

-- Converted from DG Script #53455: major_globe_command_search
-- Original: WORLD trigger, flags: GLOBAL, COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" then
    _return_value = false
    return _return_value
end
if (actor:get_quest_stage("major_globe_spell") == 6) and (actor:get_quest_var("major_globe_spell:room") == actor.room) then
    self.room:spawn_object(534, 52)
    self.room:send_except(actor, tostring(actor.name) .. " finds " .. tostring(objects.template(534, 52).name) .. "!")
    actor:send("<blue>You have found " .. tostring(objects.template(534, 52).name) .. "!</>")
    actor.name:advance_quest("major_globe_spell")
else
    _return_value = false
end
return _return_value