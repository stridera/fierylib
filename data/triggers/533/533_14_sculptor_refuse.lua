-- Trigger: Sculptor refuse
-- Zone: 533, ID: 14
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #53314
--
-- Refuse generic items the sculptor cannot use. Items associated with
-- the wand-typing or wall_ice quests are passed through (return true)
-- so other RECEIVE triggers can handle them; everything else is
-- refused with a context-appropriate message.
--
-- Original DG had probability 0% (synthetic gate); removed -- a refuse
-- trigger needs to fire on every receive to filter properly.
--
-- TODO: Original referenced quest variables `%wandgem%`, `%wandtask3%`,
-- `%wandtask4%`, `%wand_id%` to hold proto ids of wand-quest items.
-- Resolve these to actual zone/id pairs in the new schema before
-- enabling this trigger; currently the bypass condition is a stub
-- (always false), so all items are refused.

-- TODO: Replace with real wand-quest item ID checks once ids are known.
local is_wand_quest_item = false

if is_wand_quest_item then
    return true  -- pass through to other triggers
end

local response
if actor:get_quest_stage("wall_ice") and actor:get_quest_stage("type_wand") == "wandstep" then
    response = "This won't help us build this wall and I can't craft with it."
elseif actor:get_quest_stage("type_wand") == "wandstep" then
    response = "I can't craft with this."
elseif actor:get_quest_stage("wall_ice") then
    response = "This won't help us build this wall."
else
    response = "What is this for?"
end

self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
self:say(response)
return false  -- block the receive
