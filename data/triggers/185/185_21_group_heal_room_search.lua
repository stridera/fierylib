-- Trigger: group_heal_room_search
-- Zone: 185, ID: 21
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18521

-- Converted from DG Script #18521: group_heal_room_search
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on arg
if arg == "s" or arg == "se" then
    _return_value = false
    return _return_value
end
if (actor:get_quest_stage("group_heal") == 3) and (actor:get_quest_var("group_heal:room") == self.id) then
    self.room:spawn_object(185, 14)
    self.room:send_except(actor, tostring(actor.name) .. " finds " .. tostring(objects.template(185, 14).name) .. "!")
    actor:send("<blue>You have found " .. tostring(objects.template(185, 14).name) .. "!</>")
    actor.name:advance_quest("group_heal")
else
    _return_value = false
end
return _return_value