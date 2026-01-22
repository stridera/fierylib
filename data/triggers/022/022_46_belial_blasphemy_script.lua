-- Trigger: belial_blasphemy_script
-- Zone: 22, ID: 46
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2246

-- Converted from DG Script #2246: belial_blasphemy_script
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- blasphemy = 325-400hp demonic unholy word!
wait(1)
self.room:send("Belial throws his hands in the air, uttering in demonic, 'Verai Thak!")
local victim = self.people
while victim do
    if (victim.id == -1) and (victim.level < 100) then
        local damage = 325 + random(1, 75)
        victim:send("You cover your ears in horror upon hearing the demonic oath! (<b:red>" .. tostring(damage) .. "</>)")
        self.room:send_except(victim, tostring(victim.name) .. " covers " .. tostring(victim.possessive) .. " ears in horror upon hearing the demonic oath! (<blue>" .. tostring(damage) .. "</>)")
        local damage_dealt = victim:damage(damage)  -- type: physical
    end
    local victim = victim.next_in_room
end
-- blasphemy = 325-400hp demonic unholy word!
wait(1)
self.room:send("Belial throws his hands in the air, uttering in demonic, 'Verai Thak!")
local victim = self.people
while victim do
    local next = victim.next_in_room
    if (victim.id == -1) and (victim.level < 100) then
        local damage = 325 + random(1, 75)
        victim:send("You cover your ears in horror upon hearing the demonic oath! (<b:red>" .. tostring(damage) .. "</>)")
        self.room:send_except(victim, tostring(victim.name) .. " covers " .. tostring(victim.possessive) .. " ears in horror upon hearing the demonic oath! (<blue>" .. tostring(damage) .. "</>)")
        local damage_dealt = victim:damage(damage)  -- type: physical
    end
    local victim = next
end