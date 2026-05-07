-- Trigger: Khysan refuse
-- Zone: 103, ID: 25
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #10325
-- Catch-all RECEIVE handler that runs after the per-stage receive
-- triggers (103_13, 103_19..24). For wand-quest items and the
-- per-stage expected ice_shards items the legacy script fell
-- through (`halt`) to let the dedicated receive trigger handle
-- the gift; for everything else it returned 0 (decline) and
-- printed a stage-appropriate refusal line.
--
-- Returns:
--   true  -> let the gift land (a sibling trigger handles it)
--   false -> consume / decline, with the refusal echo below
--
-- TODO(parity): the original DG branched on `%wandgem%`,
-- `%wandtask3%`, `%wandtask4%`, `%wandvnum%` to recognise
-- wand-quest deliveries. Those are DG context globals from the
-- wand-quest framework and are not yet ported. Until they are,
-- the wand-quest fall-through is approximated as "no match"
-- (the wand-receive triggers are not in this zone), and the
-- refusal will fire even for legitimate wand offerings. Restore
-- once the wand framework lands.

local function is_obj(z, i)
    return object.zone_id == z and object.local_id == i
end

local stage = actor:get_quest_stage("ice_shards")
local response

if stage == 1 then
    -- Books: 16209 (162, 9), 18505 (185, 5), 55003 (550, 3),
    -- 58415 (584, 15)
    if is_obj(162, 9) or is_obj(185, 5) or is_obj(550, 3) or is_obj(584, 15) then
        return true
    end
    response = "This isn't one of the four books I need to consult."
elseif stage == 2 then
    -- 55004 → (550, 4)
    if is_obj(550, 4) then
        return true
    end
    response = "This isn't the Codex of War."
elseif stage == 3 then
    -- 58806 → (588, 6)
    if is_obj(588, 6) then
        return true
    end
    response = "This isn't Commander Thraja's journal..."
elseif stage == 6 then
    -- 48502 → (485, 2)
    if is_obj(485, 2) then
        return true
    end
    response = "Weird, this doesn't look like a map of Ickle."
elseif stage == 7 then
    -- 53423 → (534, 23)
    if is_obj(534, 23) then
        return true
    end
    response = "Do you think we can get new information from " .. tostring(object.shortdesc) .. "?  I doubt it..."
elseif stage == 8 then
    -- 43013 → (430, 13)
    if is_obj(430, 13) then
        return true
    end
    response = "Is this a book?"
elseif stage == 10 then
    -- 10325 → (103, 25)
    if is_obj(103, 25) then
        return true
    end
    response = "Is this all you could find?"
else
    response = "Oh, is this a gift for me?  I appreciate it, but I'm fine for now."
end

self.room:send(self.name .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
self:say(response)
return false
