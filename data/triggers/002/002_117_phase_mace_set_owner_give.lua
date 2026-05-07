-- Trigger: Phase mace set owner give
-- Zone: 2, ID: 117
-- Type: OBJECT, Flags: GIVE
--
-- Refuses giving the phase mace to the wrong questmaster. Each priest is
-- mapped to a specific macestep; the player's quest stage must match before
-- the mace will be accepted. The very first priest (mob 30:25) auto-starts
-- the quest if the player hasn't begun yet.
--
-- TODO(parity): victim ids here are legacy 5-digit vnums, not (zone, id)
-- composites. Migrate to victim.zone_id/victim.local_id once the proper
-- mapping table is restored.
local _return_value = true  -- Default: allow action
local macestep
if victim.id == 3025 then
    macestep = 1
    if not actor:get_quest_stage("phase_mace") then
        actor:start_quest("phase_mace")
    end
elseif victim.id == 18502 then
    macestep = 2
elseif victim.id == 10000 then
    macestep = 3
elseif victim.id == 6218 then
    macestep = 4
elseif victim.id == 8501 then
    macestep = 5
elseif victim.id == 18581 then
    macestep = 6
elseif victim.id == 6007 then
    macestep = 7
elseif victim.id == 48412 then
    macestep = 8
elseif victim.id == 3021 then
    macestep = 9
else
    if victim.is_npc then
        actor:send("You shouldn't give away something so precious!")
    end
    return _return_value
end
local response
if actor:get_quest_stage("phase_mace") < macestep then
    response = "This isn't yours!  I can't help you properly improve a mace that doesn't belong to you."
elseif actor:get_quest_stage("phase_mace") > macestep then
    response = "I've already done everything I can to help you."
end
if response then
    self.room:send(tostring(victim.name) .. " refuses " .. tostring(self.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(victim.name) .. " tells you, '" .. response .. "'")
end
return _return_value
