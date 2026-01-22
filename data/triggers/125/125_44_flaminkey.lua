-- Trigger: FlaminKey
-- Zone: 125, ID: 44
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #12544

-- Converted from DG Script #12544: FlaminKey
-- Original: OBJECT trigger, flags: GET, probability: 100%
local burn = 1
wait(1)
if string.find(actor.class, "Cry") then
    actor.name:send("Your cool touch makes the fiery key's heat bearable.")
    local burn = 0
end
if string.find(actor.class, "Pyr") then
    local burn = 0
    actor.name:send("Your hands are accustomed to the heat, making the key easy to handle.")
end
if burn == 1 then
    actor.name:damage(50)  -- type: fire
    if damage_dealt ~= 0 then
        actor:send("OUCH!  You grab the key, but it's burning your hand! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " yelps as the key burns " .. tostring(actor.possessive) .. " hand! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end