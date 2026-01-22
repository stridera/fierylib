-- Trigger: phase weapon owner wield check
-- Zone: 3, ID: 5
-- Type: OBJECT, Flags: WEAR
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #305

-- Converted from DG Script #305: phase weapon owner wield check
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if self.id >= 300 and self.id <= 339 then
    if self.id >= 300 and self.id <= 309 then
        local type = "air"
    elseif self.id >= 310 and self.id <= 319 then
        local type = "fire"
    elseif self.id >= 320 and self.id <= 329 then
        local type = "ice"
    elseif self.id >= 330 and self.id <= 339 then
        local type = "acid"
    end
    if actor.quest_stage[type_wand] < (self.level% / 10) + 2 then
        _return_value = false
        actor:send("This weapon is bound to someone else!")
    else
        -- switch on self.id
        if not actor.quest_stage[type_wand] then
            if self.id == 300 or self.id == 310 or self.id == 320 or self.id == 330 then
                actor:start_quest("%type%_wand")
            end
        end
    end
elseif self.id >= 340 and self.id <= 349 then
    -- switch on self.id
    if not actor:get_quest_stage("phase_mace") then
        if self.id == 340 then
            actor:start_quest("phase_mace")
        end
    end
    if actor:get_quest_stage("phase_mace")self.level% / 10) + 1 then
        _return_value = false
        actor:send("This weapon is bound to someone else!")
    end
end
return _return_value