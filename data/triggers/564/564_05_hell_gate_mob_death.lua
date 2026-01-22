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
    -- switch on self.id
    local blood = nil
    if self.id == 12010 then
        blood = 56400
    elseif self.id == 30054 then
        blood = 56401
    elseif self.id == 32408 then
        blood = 56402
    elseif self.id == 48125 then
        blood = 56403
    elseif self.id == 48126 then
        blood = 56404
    elseif self.id == 51003 or self.id == 51018 or self.id == 51023 then
        blood = 56405
    elseif self.id == 55238 then
        blood = 56406
    end
    if blood and not actor:get_quest_var("hell_gate:blood" .. blood) then
        actor:set_quest_var("hell_gate", "blood" .. blood, 1)
        self.room:spawn_object(vnum_to_zone(blood), vnum_to_local(blood))
    end
end