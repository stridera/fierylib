-- Trigger: hell_gate_mob_death
-- Zone: 564, ID: 5
-- Type: MOB, Flags: DEATH
-- Status: CLEAN (fixed)
--
-- Original DG Script: #56405

-- Converted from DG Script #56405: hell_gate_mob_death
-- Original: MOB trigger, flags: DEATH, probability: 35%

-- 35% chance to trigger
if not percent_chance(35) then
    return true
end
if actor:get_quest_stage("hell_gate") == 3 and actor:has_equipped("56407") then
    -- switch on self.id (zone_id, local_id pairs)
    local blood_zone, blood_local = nil, nil
    if self.zone_id == 120 and self.id == 10 then
        blood_zone, blood_local = 564, 0
    elseif self.zone_id == 300 and self.id == 54 then
        blood_zone, blood_local = 564, 1
    elseif self.zone_id == 324 and self.id == 8 then
        blood_zone, blood_local = 564, 2
    elseif self.zone_id == 481 and self.id == 25 then
        blood_zone, blood_local = 564, 3
    elseif self.zone_id == 481 and self.id == 26 then
        blood_zone, blood_local = 564, 4
    elseif self.zone_id == 510 and (self.id == 3 or self.id == 18 or self.id == 23) then
        blood_zone, blood_local = 564, 5
    elseif self.zone_id == 552 and self.id == 38 then
        blood_zone, blood_local = 564, 6
    end
    if blood_zone and not actor:get_quest_var("hell_gate:blood" .. blood_zone .. "_" .. blood_local) then
        actor:set_quest_var("hell_gate", "blood" .. blood_zone .. "_" .. blood_local, 1)
        self.room:spawn_object(blood_zone, blood_local)
    end
end