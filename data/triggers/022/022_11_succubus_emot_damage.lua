-- Trigger: Succubus_Emot_Damage
-- Zone: 22, ID: 11
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2211

-- Converted from DG Script #2211: Succubus_Emot_Damage
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local target = 0
local loop = 0
while target == 0 do
    local dice = random(1, 50)
    local damage = 75 + dice
    local victim = room.actors[random(1, #room.actors)]
    if (victim.id ~= -1) or (victim.gender ~= "Male") then
        if loop > 10 then
            local target = 1
        else
            local loop = loop + 1
        end
    else
        local target = 1
        local message = random(1, 4)
        -- switch on message
        if message == 1 then
            self.room:send_except(victim, "A Succubus reaches in and fondles " .. tostring(victim.name) .. " gently. (<blue>" .. tostring(damage) .. "</>)")
            victim:send("A Succubus reaches in and fondles you gently. (<b:red>" .. tostring(damage) .. "</>)")
        elseif message == 2 then
            self.room:send_except(victim, "A Succubus kisses " .. tostring(victim.name) .. " passionately... (<blue>" .. tostring(damage) .. "</>)")
            victim:send("A Succubus kisses you passionately, it seems to last forever... (<b:red>" .. tostring(damage) .. "</>)")
        elseif message == 3 then
            self.room:send_except(victim, "A Succubus gropes at " .. tostring(victim.name) .. ". How inappropriate! (<blue>" .. tostring(damage) .. "</>)")
            victim:send("A Succubus gropes you wildly! Boy does that feel good! (<b:red>" .. tostring(damage) .. "</>)")
        else
            self.room:send_except(victim, "A Succubus strokes " .. tostring(victim.name) .. "'s inner thigh. (<blue>" .. tostring(damage) .. "</>)")
            victim:send("A Succubus strokes your inner thigh. She's getting frisky! (<b:red>" .. tostring(damage) .. "</>)")
        end
        local damage_dealt = victim:damage(damage)  -- type: physical
        local target = 1
    end
end