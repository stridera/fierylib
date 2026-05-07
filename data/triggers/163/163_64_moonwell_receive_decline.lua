-- Trigger: Moonwell receive decline
-- Zone: 163, ID: 64
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16364
--
-- Catch-all RECEIVE handler for the moonwell dryad: lets the right item
-- through for each stage (so the per-item RECEIVE triggers handle it) and
-- politely refuses anything else.
--
-- TODO(parity): object.id here is the legacy 5-digit vnum (e.g. 16350,
-- 48024). Update to (zone, id) tuple comparisons once the catalog ID
-- format on object instances is stable.

local stage = actor:get_quest_stage("moonwell_spell_quest")

if (stage == 1 or stage == 2 or stage == 3) and object.id == 16350 then
    return true
elseif (stage == 3 or stage == 4) and object.id == 48024 then
    return true
elseif (stage == 4 or stage == 5 or stage == 6) and object.id == 16356 then
    return true
elseif stage == 6 and object.id == 5201 then
    return true
elseif stage == 7 and (object.id == 16006 or object.id == 16351) then
    return true
elseif stage == 8 and object.id == 16352 then
    return true
elseif stage == 9 and object.id == 49011 then
    return true
elseif stage == 10 and (object.id == 4003 or object.id == 16353) then
    return true
elseif stage == 11 and (object.id == 55020 or object.id == 16354 or object.id == 16355) then
    return true
end

wait(2)
actor:send(tostring(self.name) .. " tells you, 'I do not want this from you.'")
actor:send(tostring(self.name) .. " returns your item to you.")
return false  -- block the receive: bounce the item back to the actor
