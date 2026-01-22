-- Trigger: bad_wedding_ring
-- Zone: 481, ID: 11
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #48111

-- Converted from DG Script #48111: bad_wedding_ring
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor.id ~= 48105 then
    wait(2)
    self.room:send("The ivory ring flares brightly!")
    actor:damage(100)  -- type: fire
    if damage_dealt ~= 0 then
        self.room:send_except(actor, tostring(actor.name) .. " shouts in surprise and pain. (<b:red>" .. tostring(damage_dealt) .. "</>)")
        if actor.inventory[self.vnum] then
            actor:send("You are burnt by the ring and drop it! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            actor:command("drop ivory-ring")
        else
            actor:send("You are burnt by the ring! (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
        if actor.room == 48223 then
            self.room:find_actor("vulcera"):command("get ivory-ring")
        end
    end
end