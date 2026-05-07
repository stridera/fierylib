-- Trigger: Niaxxa ejects her opponent
-- Zone: 615, ID: 35
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #61535

-- Converted from DG Script #61535: Niaxxa ejects her opponent
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if not self:has_equipped(615, 14) then
    self:command("get singing")
    self:command("wield singing")
elseif actor.level < 20 and self:has_equipped(615, 14) and self.room.zone_id == 615 and self.room.local_id == 67 then
    local outcome = 0
    if actor.level <= 4 then
        outcome = random(1, 8)
    elseif actor.level <= 8 then
        outcome = random(1, 10)
    elseif actor.level <= 15 then
        outcome = random(1, 15)
    else
        outcome = random(1, 20)
    end
    if outcome == 1 then
        wait(3)
        local val = random(1, 3)
        if val == 1 then
            self:say("I tire of your foolishness.")
        elseif val == 2 then
            self:say("You waste my time.")
        else
            self:say("You bore me, " .. tostring(actor.class) .. ".")
        end
        actor:send(tostring(self.name) .. " swiftly loops her chain around your exposed wrist, and yanks!")
        self.room:send_except(actor, tostring(self.name) .. " loops her chain around " .. tostring(actor.name) .. "'s wrist, and yanks it!")
        actor:send("You are sent reeling out of the room!")
        self.room:send_except(actor, tostring(actor.name) .. " is sent reeling out of the room!")
        actor:teleport(get_room(615, 67 + random(1, 6)))
    end
end