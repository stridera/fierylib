-- Trigger: ice_shards_library_search
-- Zone: 103, ID: 17
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #10317

-- Converted from DG Script #10317: ice_shards_library_search
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ice_shards") == 9 then
    actor.name:advance_quest("ice_shards")
    self.room:spawn_object(103, 25)
    actor:send("You find " .. tostring(objects.template(103, 25).name) .. "!")
    self.room:send_except(actor, tostring(actor.name) .. " finds " .. tostring(objects.template(103, 25).name) .. "!")
else
    _return_value = false
end
return _return_value