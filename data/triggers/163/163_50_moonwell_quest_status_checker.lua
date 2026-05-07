-- Trigger: moonwell_quest_status_checker
-- Zone: 163, ID: 50
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #16350
--
-- Player asks the dryad for "status" / "progress" — replays which item to
-- fetch next and where it's hidden. Stages 8 and 12 instead prompt the
-- player to hand over the map for marking.

local sl = string.lower(speech)
if not (string.find(sl, "status") or string.find(sl, "progress")) then
    return true
end

wait(2)

if actor:get_has_completed("moonwell_spell_quest") then
    self:say("I have already taught you to travel through moonwells.")
    return true
end

local stage = actor:get_quest_stage("moonwell_spell_quest")
local item, place

if stage == 1 or stage == 2 then
    item = {163, 50}  -- Vine of Mielikki (16350)
    place = "an island of lava and fire."
elseif stage == 3 then
    item = {480, 24}  -- The Heartstone (48024)
    place = "an ancient burial site far to the north"
elseif stage == 4 or stage == 5 then
    item = {163, 56}  -- Flask of Eleweiss (16356)
    place = "the cult of the ice dragon"
elseif stage == 6 then
    item = {52, 1}  -- Glittering ruby ring (5201)
    place = "a temple dedicated to fire"
elseif stage == 7 then
    item = {160, 6}  -- Orb of Winds (16006)
    place = "a dark fortress to the east"
elseif stage == 8 then
    self:say("Please give me your map to update.")
    return true
elseif stage == 9 then
    item = {490, 11}  -- Jade ring (49011)
    place = "a wood nymph on an island of our brothers beset by beasts"
elseif stage == 10 then
    item = {40, 3}  -- Chaos Orb (4003)
    place = "a great dragon hidden in a hellish labyrinth"
elseif stage == 11 then
    item = {550, 20}  -- Granite Ring (55020)
    place = "a large temple hidden in a mountain"
elseif stage == 12 then
    self:say("Please give me your map to make the final markings.")
    return true
else
    self:say("You haven't agreed to help me yet.")
    return true
end

local item_name = objects.template(item[1], item[2]).name
self:say("We need:")
self.room:send("</>" .. tostring(item_name) .. " from")
self.room:send("</>" .. tostring(place) .. ".")
if stage > 6 then
    self.room:send(tostring(self.name) .. " says, 'If you need a new map, say \"<b:green>I lost my map</>\".'")
end
