-- Trigger: hell_gate_mob_death
-- Zone: 564, ID: 5
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <hell_gate_mob_death>:25: function arguments expected near ']'
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
    if self.id == 12010 then
        local blood = 0
    elseif self.id == 30054 then
        local blood = 1
    elseif self.id == 32408 then
        local blood = 2
    elseif self.id == 48125 then
        local blood = 3
    elseif self.id == 48126 then
        local blood = 4
    elseif self.id == 51003 or self.id == 51018 or self.id == 51023 then
        local blood = 5
    elseif self.id == 55238 then
        local blood = 6
    end
    if actor.quest_variable[hell_gate:bloodblood] == 0 then
        actor:set_quest_var("hell_gate", "blood%blood%", 1)
        self.room:spawn_object(564, blood)
    end
end