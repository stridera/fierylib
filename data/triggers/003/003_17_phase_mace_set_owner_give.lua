-- Trigger: Phase mace set owner give
-- Zone: 3, ID: 17
-- Type: OBJECT, Flags: GIVE
-- Status: CLEAN
--
-- Original DG Script: #317

-- Converted from DG Script #317: Phase mace set owner give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on victim.id
if victim.id == 3025 then
    local macestep = 1
    if not actor:get_quest_stage("phase_mace") then
        actor:start_quest("phase_mace")
    end
elseif victim.id == 18502 then
    local macestep = 2
elseif victim.id == 10000 then
    local macestep = 3
elseif victim.id == 6218 then
    local macestep = 4
elseif victim.id == 8501 then
    local macestep = 5
elseif victim.id == 18581 then
    local macestep = 6
elseif victim.id == 6007 then
    local macestep = 7
elseif victim.id == 48412 then
    local macestep = 8
elseif victim.id == 3021 then
    local macestep = 9
else
    if victim.id ~= -1 then
        _return_value = false
        actor:send("You shouldn't give away something so precious!")
    end
    return _return_value
end
if actor:get_quest_stage("phase_mace") < macestep then
    local response = "This isn't yours!  I can't help you properly improve a mace that doesn't belong to you."
elseif actor:get_quest_stage("phase_mace") > macestep then
    local response = "I've already done everything I can to help you."
end
if response then
    _return_value = false
    self.room:send(tostring(victim.name) .. " refuses " .. tostring(self.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(victim.name) .. " tells you, '" .. tostring(response) .. "'")
end
return _return_value