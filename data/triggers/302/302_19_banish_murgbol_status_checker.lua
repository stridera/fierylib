-- Trigger: banish_murgbol_status_checker
-- Zone: 302, ID: 19
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #30219

-- Speech keywords: status, progress
-- TODO: Confirm the (zone, local_id) decomposition for each stage's target mob.
-- Original DG Script used legacy global vnums (e.g. 41119 -> zone 411, id 19).
-- These mappings assume zone 0 -> zone 1000 was *not* used by these mobs.
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "status") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("banish")
if actor:get_has_completed("banish") then
    self:say("I have taught you all I can.")
    return true
end
if stage == 0 or stage == nil then
    self:say("I'm not teaching you right now...")
    return true
end
local mob_zone, mob_id, place, known
if stage == 1 then
    mob_zone, mob_id = 411, 19
    place = "her chamber under the ocean waves"
    known = "Nothing."
elseif stage == 2 then
    mob_zone, mob_id = 533, 13
    place = "the frozen tunnels of the north"
    known = "v"
elseif stage == 3 then
    mob_zone, mob_id = 370, 0
    place = "a deep and ancient mine"
    known = "vi"
elseif stage == 4 then
    mob_zone, mob_id = 480, 5
    place = "a room filled with art in an ancient barrow"
    known = "vib"
elseif stage == 5 then
    mob_zone, mob_id = 534, 17
    place = "the cold valley of the far north"
    known = "vibu"
elseif stage == 6 then
    mob_zone, mob_id = 238, 11
    place = "a nearby fortress of clouds and crystals"
    known = "vibug"
elseif stage == 7 then
    self.room:send(tostring(self.name) .. " says, 'Come, speak the prayer aloud: <b:magenta>vibugp</>!'")
    return true
else
    return true
end
local mob_name = mobiles.template(mob_zone, mob_id).name
self.room:send(tostring(self.name) .. " says, 'To learn Banish you must next:'")
self.room:send("- kill " .. tostring(mob_name) .. " in " .. tostring(place) .. ".")
self.room:send("</>Your knowledge of the prayer so far: \"<b:cyan>" .. tostring(known) .. "</>\"")
return true