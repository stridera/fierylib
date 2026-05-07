-- Trigger: bad_wedding_ring
-- Zone: 481, ID: 11
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #48111

-- Converted from DG Script #48111: bad_wedding_ring
-- Original: OBJECT trigger, flags: GET, probability: 100%
if not (actor.zone_id == 481 and actor.local_id == 5) then
    wait(2)
    self.room:send("The ivory ring flares brightly!")
    actor:damage(100)  -- type: fire
    if damage_dealt ~= 0 then
        self.room:send_except(actor, tostring(actor.name) .. " shouts in surprise and pain. (<b:red>" .. tostring(damage_dealt) .. "</>)")
        if actor:has_item(self.zone_id, self.local_id) then
            actor:send("You are burnt by the ring and drop it! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            actor:command("drop ivory-ring")
        else
            actor:send("You are burnt by the ring! (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
        -- TODO(parity): legacy DG referenced room vnum 48223 (likely a typo
        -- for 48123 == (481,123), Vulcera's punishment chamber).
        if actor.room and actor.room.zone_id == 481 and actor.room.local_id == 123 then
            self.room:find_actor("vulcera"):command("get ivory-ring")
        end
    end
end