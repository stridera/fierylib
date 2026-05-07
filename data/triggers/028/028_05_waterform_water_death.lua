-- Trigger: waterform_water_death
-- Zone: 28, ID: 5
-- Type: MOB, Flags: DEATH
-- Status: REVIEWED (region switch fixed; nil-safe sample tally; group iteration normalized)
--
-- Original DG Script: #2805
-- When a "water creature" dies, any group member in the same room who is on
-- waterform stage 4 and is carrying or wearing the dragon bone cup (28:8)
-- gets credit for that creature's region. Each region can only be tallied
-- once per player. After 4 regions are tallied, advance the quest.
--
-- Region map (composite mob IDs):
--   region1: Blue-Fog (self 28:5, 28:8 [unused twin], 28:9, 118:5)
--   region2: Nordus      (self 510:1, 510:19, 510:21)
--   region3: Layveran    (self 40:2)
--   region4: default     (everything else, e.g. Plane of Water)
--   region5: sunken castle (self 530:4)
-- Note: mob 486:31 was excluded in the original DG (no region credit).
-- TODO: confirm intended exclusion behavior for 486:31.

local function region_for(zone, local_id)
    if zone == 28 and (local_id == 5 or local_id == 8 or local_id == 9) then
        return 1
    elseif zone == 118 and local_id == 5 then
        return 1
    elseif zone == 510 and (local_id == 1 or local_id == 19 or local_id == 21) then
        return 2
    elseif zone == 40 and local_id == 2 then
        return 3
    elseif zone == 530 and local_id == 4 then
        return 5
    elseif zone == 486 and local_id == 31 then
        return nil  -- excluded
    else
        return 4
    end
end

local function maybe_credit(person)
    if person.room ~= self.room then
        return
    end
    if person:get_quest_stage("waterform") ~= 4 then
        return
    end
    -- Must have the dragon bone cup (28:8) in inventory or equipped.
    if not (person:has_item("dragon-bone-cup") or person:has_equipped(28, 8)) then
        return
    end
    local number = region_for(self.zone_id, self.local_id)
    if not number then
        return
    end
    local region_key = "region" .. tostring(number)
    if not person:get_quest_var("waterform:" .. region_key) then
        person:set_quest_var("waterform", region_key, 1)
        person:send("<b:blue>You gather part of " .. tostring(self.name) ..
            " in " .. tostring(objects.template(28, 8).name) .. ".</>")
        self.room:send_except(person, "<b:blue>" .. tostring(person.name) ..
            " gathers part of " .. tostring(self.name) ..
            " in " .. tostring(objects.template(28, 8).name) .. ".</>")
    end
    local total = 0
    for r = 1, 5 do
        if person:get_quest_var("waterform:region" .. tostring(r)) then
            total = total + 1
        end
    end
    if total > 3 then
        person:send("<b:blue>You have gathered all the samples of living water you need!</>")
        person:advance_quest("waterform")
    end
end

if actor.group then
    for _, member in ipairs(actor.group) do
        maybe_credit(member)
    end
else
    maybe_credit(actor)
end
