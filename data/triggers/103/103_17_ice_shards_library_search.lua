-- Trigger: ice_shards_library_search
-- Zone: 103, ID: 17
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #10317
-- Stage 9 search: typing `search` in the library room spawns the
-- magic key (object 103,25), advances the quest, and consumes the
-- command. Other stages let the default `search` command run.

if cmd ~= "search" then
    return true
end
if actor:get_quest_stage("ice_shards") ~= 9 then
    return true
end

actor:advance_quest("ice_shards")
self.room:spawn_object(103, 25)
local key_name = objects.template(103, 25).name
actor:send("You find " .. key_name .. "!")
self.room:send_except(actor, actor.name .. " finds " .. key_name .. "!")
return false
