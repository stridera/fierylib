-- Trigger: Chimney_top_burns
-- Zone: 16, ID: 40
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #1640

-- Converted from DG Script #1640: Chimney_top_burns
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if self.actor_count > 0 then
    local damage = 1
    local vctm = room.actors[random(1, #room.actors)]
    local damage_dealt = vctm:damage(damage)  -- type: fire
    if damage_dealt == 0 then
        vctm:send("The burning smoke blows into your eyes, but you are well protected from its damage.")
        self.room:send_except(vctm, "Burning smoke billows around " .. tostring(vctm.name) .. ", deflected by " .. tostring(vctm.possessive) .. " magic.")
    else
        vctm:send("Burning smoke blows straight into your eyes!  It burns! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(vctm, tostring(vctm.name) .. " cries out in pain as " .. tostring(vctm.name) .. " is burned by the smoke in " .. tostring(vctm.possessive) .. " eyes! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end