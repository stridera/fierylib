-- Trigger: group_heal_room_search
-- Zone: 185, ID: 21
-- Type: WORLD, Flags: COMMAND
--
-- When at stage 3 of group_heal, searching the room the doctor pointed
-- to (185_20 stored "group_heal:room") yields the ritual book (185,14)
-- and advances to stage 4.
--
-- 185_20 stores the room as a legacy 5-digit vnum (zone * 100 + id); this room's
-- own (zone_id, id) is turned into that number to compare. Keep in lockstep with 185_20.

if not (cmd == "search") then
    return true
end

if arg == "s" or arg == "se" then
    return true
end

if actor:get_quest_stage("group_heal") == 3 and actor:get_quest_var("group_heal:room") == require("dg").to_vnum(self.zone_id, self.id) then
    self.room:spawn_object(185, 14)
    self.room:send_except(actor, tostring(actor.name) .. " finds " .. tostring(objects.template(185, 14).name) .. "!")
    actor:send("<blue>You have found " .. tostring(objects.template(185, 14).name) .. "!</>")
    actor:advance_quest("group_heal")
end
return true