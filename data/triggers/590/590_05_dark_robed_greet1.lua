-- Trigger: dark_robed_greet1
-- Zone: 590, ID: 5
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #59005

-- Converted from DG Script #59005: dark_robed_greet1
-- Original: MOB trigger, flags: GREET, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
if not (actor.is_player and actor.level < 100) then
    return true
end
local stage = actor:get_quest_stage("sacred_haven")
if stage == 1 and actor:get_quest_var("sacred_haven:given_light") ~= 1 then
    wait(6)
    actor:send(tostring(self.name) .. " whispers to you, 'Have you located the adornment of light")
    actor:send("</>for me?'")
elseif stage > 1 and actor:get_quest_var("sacred_haven:given_blood") ~= 1 and actor:get_quest_var("sacred_haven:given_earring") ~= 1 then
    wait(4)
    self:whisper(actor.name, "Have you brought me my artifacts?")
elseif stage < 1 then
    wait(4)
    local found_evil = false
    for _, target in ipairs(self.room.actors) do
        if target.alignment <= -350 and target.is_player and target.level < 100 then
            self:whisper(target.name, "Ah, I sense a wicked aura around your soul.")
            wait(5)
            target:send(tostring(self.name) .. " slowly walks up and leans in close towards you.")
            self.room:send_except(target, tostring(self.name) .. " slowly walks up and leans close towards " .. tostring(target.name) .. ".")
            wait(7)
            target:send(tostring(self.name) .. " whispers to you, 'I am willing to offer you a reward,")
            target:send("</>if only you can help me.'")
            found_evil = true
            break
        end
    end
    if not found_evil and actor.alignment > -350 then
        self:emote("slowly turns away from you, pulling his hood farther down to cover his face.")
    end
end