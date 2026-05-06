-- Trigger: FireBreather
-- Zone: 125, ID: 22
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12522

-- Converted from DG Script #12522: FireBreather
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
-- Note: self is an Object; use 'room' global for the containing room
local actors = room.actors
if #actors > 0 then
    room:send("The dragon starts to rumble.")
    wait(2)
    room:send("The dragon blasts a gout of <b:red>flame</>, incinerating the room.")
    local prsn = actors[random(1, #actors)]
    local dmg = random(1, 100) + 50
    local damage_dealt = prsn:damage(dmg)
    if damage_dealt == 0 then
        room:send_except(prsn, "A fiery blast is absorbed by " .. tostring(prsn.name) .. ".")
        prsn:send("Your body is hit by a <red>fiery</> blast! Luckily you absorb the blast.")
    else
        room:send_except(prsn, tostring(prsn.name) .. " is caught in the fiery blast! (<red>" .. tostring(damage_dealt) .. "</>)")
        prsn:send("You are caught in the <red>fiery</> blast! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end
