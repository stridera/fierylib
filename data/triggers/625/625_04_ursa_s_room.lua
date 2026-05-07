-- Trigger: ursa's room
-- Zone: 625, ID: 4
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #62504

-- Converted from DG Script #62504: ursa's room
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
--
-- Called from 625_09 (Ursa's GREET/FIGHT). `self` is the room.
-- Ursa lets out a roar; everyone in the room except Ursa
-- takes damage scaled to their level. Rangers and druids are
-- invigorated rather than hurt; Ursa himself (mild form 62507
-- and enraged form 62550) is exempt; high-level (>=100) chars
-- are exempt as well.
local ursa = self.room:find_actor("Ursa")
self.room:send_except(ursa, "&9<blue>Ursa makes your frame quake with a vicious <red>ROOOOOAAAAAARRRRRR!</>")
for _, target in ipairs(self.actors) do
    local is_ursa = (target.zone_id == 625 and (target.local_id == 7 or target.local_id == 50))
    if not is_ursa and target.level < 100 then
        local dam = math.floor(1.5 * target.level - random(1, 12))
        if target.class == "Ranger" or target.class == "Druid" then
            target:send("<yellow>Ursa's roar invigorates your wild spirit!<b:yellow></> (<b:red>0</>)")
            self.room:send_except(target, "<yellow>Ursa's roar invigortates " .. tostring(target.name) .. "'s wild spirit!</> (<b:red>0</>)")
        else
            local damage_dealt = target:damage(dam)  -- type: physical
            target:send("<b:yellow>You shrink in pain at Ursa's mighty roar!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(target, "<yellow>Ursa's roar causes " .. tostring(target.name) .. " to shrink in pain.</> (<blue>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end
