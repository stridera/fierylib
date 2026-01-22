-- Trigger: FireBreather
-- Zone: 125, ID: 22
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12522

-- Converted from DG Script #12522: FireBreather
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
local room = get.room[self.room]
if room.people then
    self.room:send("The dragon starts to rumble.")
    wait(2)
    self.room:send("The dragon blasts a gout of <b:red>flame</>, incinerating the room.")
    local prsn = room.actors[random(1, #room.actors)]
    local dmg = random(1, 100)
    local dmg = dmg + 50
    local damage_dealt = prsn:damage(dmg)  -- type: fire
    if damage_dealt == 0 then
        if fireproof then
            self.room:send_except(prsn.name, "A fiery blast is absorbed by " .. tostring(prsn.name) .. ".")
            prsn.name:send("Your body is hit by a <red>fiery</> blast! Luckily you absorb the blast.")
        else
            self.room:send_except(prsn.name, tostring(prsn.name) .. " is caught in the fiery blast! (<red>" .. tostring(damage_dealt) .. "</>)")
            prsn.name:send("You are caught in the <red>fiery</> blast! (<red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end