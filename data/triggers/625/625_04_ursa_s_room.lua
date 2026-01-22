-- Trigger: ursa's room
-- Zone: 625, ID: 4
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #62504

-- Converted from DG Script #62504: ursa's room
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local pop = self.actor_count
local count = 0
local target = self.people
self.room:send_except(self.room:find_actor("Ursa"), "&9<blue>Ursa makes your frame quake with a vicious <red>ROOOOOAAAAAARRRRRR!</>")
while count < pop do
    local dam = 1.5*target.level - random(1, 12)
    if target.id ~= 62507 and target.id ~= 62550 and target.level < 100 then
        if target.class == "RANGER" or target.class == "DRUID" then
            target:send("<yellow>Ursa's roar invigorates your wild spirit!<b:yellow></> (<b:red>0</>)")
            self.room:send_except(target, "<yellow>Ursa's roar invigortates " .. tostring(target.name) .. "'s wild spirit!</> (<b:red>0</>)")
        else
            local damage_dealt = target:damage(dam)  -- type: physical
            target:send("<b:yellow>You shrink in pain at Ursa's mighty roar!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(target, "<yellow>Ursa's roar causes " .. tostring(target.name) .. " to shrink in pain.</> (<blue>" .. tostring(damage_dealt) .. "</>)")
        end
    end
    local target = target.next_in_room
    local count = count + 1
end