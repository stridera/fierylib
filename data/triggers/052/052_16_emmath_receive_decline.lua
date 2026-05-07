-- Trigger: Emmath receive decline
-- Zone: 52, ID: 16
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5216
--
-- Catch-all decline message Emmath gives when handed the wrong item.
-- Legacy DG used probability 0 to flag this as a fallback-only trigger,
-- explicitly invoked from other receive handlers — preserved as a guard
-- so it never auto-fires on every receive. Picks the response from the
-- most specific outstanding quest stage.

if not percent_chance(0) then
    return true
end

local stage_subclass = actor:get_quest_stage("pyromancer_subclass") or 0
local response
if stage_subclass > 0 and stage_subclass <= 4 then
    response = "I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame, not this nonsense."
elseif actor:get_quest_stage("type_wand") then
    response = "I can't craft with this!"
elseif (actor:get_quest_stage("emmath_flameball") or 0) > 1 then
    response = "You're supposed to be out collecting flames, not whatever this is."
else
    response = "Why are you bringing me this trash?"
end

self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
return true