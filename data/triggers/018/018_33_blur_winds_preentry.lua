-- Trigger: blur_winds_preentry
-- Zone: 18, ID: 33
-- Type: WORLD, Flags: PREENTRY
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <blur_winds_preentry>:21: function arguments expected near ']'
--
-- Original DG Script: #1833

-- Converted from DG Script #1833: blur_winds_preentry
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("blur") == 4 then
    -- switch on self.id
    if self.id == 10001 then
        local direction = "north"
        local mob = 19
    elseif self.id == 2460 then
        local direction = "south"
        local mob = 20
    elseif self.id == 48223 then
        local direction = "east"
        local mob = 21
    elseif self.id == 20379 then
        local direction = "west"
        local mob = 22
    else
        _return_value = true
    end
    if actor.quest_variable[blur:direction] == 0 and get.mob_count[mob] == 0 then
        self.room:spawn_mobile(18, mob)
    end
end
return _return_value