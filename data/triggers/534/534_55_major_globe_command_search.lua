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
-- 534_65 stores the target room as a legacy vnum (zone * 100 + id) in `major_globe_spell:room`;
-- the room handle is turned into that number to compare.
if (actor:get_quest_stage("major_globe_spell") == 6) and (actor:get_quest_var("major_globe_spell:room") == require("dg").to_vnum(actor.room.zone_id, actor.room.local_id)) then
    self.room:spawn_object(534, 52)
    self.room:send_except(actor, tostring(actor.name) .. " finds " .. tostring(objects.template(534, 52).name) .. "!")
    actor:send("<blue>You have found " .. tostring(objects.template(534, 52).name) .. "!</>")
    actor:advance_quest("major_globe_spell")
end
return true