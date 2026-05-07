-- Trigger: group_heal_room_search
-- Zone: 185, ID: 21
-- Type: WORLD, Flags: COMMAND
--
-- When at stage 3 of group_heal, searching the room the doctor pointed
-- to (185_20 stored "group_heal:room") yields the ritual book (185,14)
-- and advances to stage 4.
--
-- TODO(parity): the stored room var is a legacy 5-digit room vnum, but
-- self.id may not match that. Either store (zone_id, local_id) in 185_20
-- and compare both fields here, or update the runtime to expose a
-- compatible self.id. Keep in lockstep with 185_20's TODO.

if not (cmd == "search") then
    return true
end

if arg == "s" or arg == "se" then
    return true
end

if actor:get_quest_stage("group_heal") == 3 and actor:get_quest_var("group_heal:room") == self.id then
    self.room:spawn_object(185, 14)
    self.room:send_except(actor, tostring(actor.name) .. " finds " .. tostring(objects.template(185, 14).name) .. "!")
    actor:send("<blue>You have found " .. tostring(objects.template(185, 14).name) .. "!</>")
    actor:advance_quest("group_heal")
end
return true