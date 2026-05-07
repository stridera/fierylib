-- Trigger: hell_gate_island_drop
-- Zone: 564, ID: 6
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #56406
--
-- Hell-gate stage 3: when a player drops one of the seven blood vials
-- ((564, 0..6)) on the island, mark it gathered. Once all seven are
-- in, advance the quest. Each blood vial can only be dropped once.

if actor:get_quest_stage("hell_gate") ~= 3 then
    return true
end

-- Only handle blood vials.
if object.zone_id ~= 564 or object.local_id < 0 or object.local_id > 6 then
    return true
end

local priest = mobiles.template(564, 0).name
local key = tostring(object.zone_id) .. "_" .. tostring(object.local_id)

if actor:get_quest_var("hell_gate:" .. key) then
    self.room:send(tostring(priest) .. " says, 'We have already gathered this blood.'")
    return false
end

actor:set_quest_var("hell_gate", key, 1)
wait(1)
self.room:send(tostring(object.shortdesc) .. " spills on the ground, gathering in a pool.")
local pool = self.room:find_actor("blood")
if pool then
    world.destroy(pool)
end

local blood1 = actor:get_quest_var("hell_gate:564_0")
local blood2 = actor:get_quest_var("hell_gate:564_1")
local blood3 = actor:get_quest_var("hell_gate:564_2")
local blood4 = actor:get_quest_var("hell_gate:564_3")
local blood5 = actor:get_quest_var("hell_gate:564_4")
local blood6 = actor:get_quest_var("hell_gate:564_5")
local blood7 = actor:get_quest_var("hell_gate:564_6")
if blood1 and blood2 and blood3 and blood4 and blood5 and blood6 and blood7 then
    actor:advance_quest("hell_gate")
    wait(2)
    self.room:send(tostring(priest) .. " says, 'I shall need the dagger to finish this step of the unsealing.  Please give it to me.'")
else
    self.room:send("The demonic voice says, <red>'This pleases me.  Bring the rest.'</>")
end
return true
