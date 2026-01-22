-- Trigger: phase wands give owner check
-- Zone: 3, ID: 4
-- Type: OBJECT, Flags: GIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #304

-- Converted from DG Script #304: phase wands give owner check
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
local _return_value = true  -- Default: allow action
local energy = nil
if self.id >= 300 and self.id <= 309 then
    energy = "air"
elseif self.id >= 310 and self.id <= 319 then
    energy = "fire"
elseif self.id >= 320 and self.id <= 329 then
    energy = "ice"
elseif self.id >= 330 and self.id <= 339 then
    energy = "acid"
end
-- switch on victim.id
if victim.id == "-1" then
    if self.id == 300 or self.id == 310 or self.id == 320 or self.id == 330 then
        if not actor.quest_stage[energy_wand] then
            -- empty branch
        elseif victim.id == 3013 then
            actor:start_quest("%energy%_wand")
        end
        return _return_value
    else
        local refuse = 1
    end
elseif victim.id == 18500 then
    local type = "air"
    local wandstep = 3
elseif victim.id == 4126 then
    local type = "fire"
    local wandstep = 3
elseif victim.id == 17806 then
    local type = "ice"
    local wandstep = 3
elseif victim.id == 10056 then
    local type = "acid"
    local wandstep = 3
elseif victim.id == 58601 then
    local type = "air"
    local wandstep = 4
elseif victim.id == 10306 then
    local type = "fire"
    local wandstep = 4
elseif victim.id == 2337 then
    local type = "ice"
    local wandstep = 4
elseif victim.id == 62504 then
    local type = "acid"
    local wandstep = 4
elseif victim.id == 12305 then
    local type = "air"
    local wandstep = 5
elseif victim.id == 12304 then
    local type = "fire"
    local wandstep = 5
elseif victim.id == 55013 then
    local type = "ice"
    local wandstep = 5
elseif victim.id == 62503 then
    local type = "acid"
    local wandstep = 5
elseif victim.id == 12302 then
    local type = "air"
    local wandstep = 6
elseif victim.id == 23811 then
    local type = "fire"
    local wandstep = 6
elseif victim.id == 23802 then
    local type = "ice"
    local wandstep = 6
elseif victim.id == 47075 then
    local type = "acid"
    local wandstep = 6
elseif victim.id == 49003 then
    local type = "air"
    local wandstep = 7
elseif victim.id == 48105 then
    local type = "fire"
    local wandstep = 7
elseif victim.id == 53316 then
    local type = "ice"
    local wandstep = 7
elseif victim.id == 4017 then
    local type = "acid"
    local wandstep = 7
elseif victim.id == 8515 then
    local type = "air"
    local wandstep = 8
elseif victim.id == 48250 then
    local type = "fire"
    local wandstep = 8
elseif victim.id == 10300 then
    local type = "ice"
    local wandstep = 8
elseif victim.id == 48029 then
    local type = "acid"
    local wandstep = 8
elseif victim.id == 6216 then
    local type = "air"
    local wandstep = 9
elseif victim.id == 48412 then
    local type = "fire"
    local wandstep = 9
elseif victim.id == 10012 then
    local type = "ice"
    local wandstep = 9
elseif victim.id == 3549 then
    local type = "acid"
    local wandstep = 9
elseif victim.id == 18581 then
    local type = "air"
    local wandstep = 10
elseif victim.id == 5230 then
    local type = "fire"
    local wandstep = 10
elseif victim.id == 55020 then
    local type = "ice"
    local wandstep = 10
elseif victim.id == 16315 then
    local type = "acid"
    local wandstep = 10
else
    local type = "none"
    local wandstep = 0
end
if actor.id == -1 then
    if type ~= "energy" then
        local refuse = 1
    elseif actor.quest_stage[energy_wand] < wandstep then
        local refuse = 2
    end
    if refuse == 1 then
        _return_value = false
        actor:send("You shouldn't give away something so precious!")
    elseif refuse == 2 then
        _return_value = false
        self.room:send(tostring(victim.name) .. " refuses " .. tostring(self.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(victim.name) .. " tells you, 'This isn't yours!  I can't help you properly improve with a " .. tostring(weapon) .. " that doesn't belong to you.'")
    end
end
return _return_value