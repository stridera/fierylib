-- Trigger: Niaxxa ejects her opponent
-- Zone: 615, ID: 35
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #61535

-- Converted from DG Script #61535: Niaxxa ejects her opponent
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if not self:has_equipped("61514") then
    self:command("get singing")
    self:command("wield singing")
elseif actor.level < 20 and self:has_equipped("61514") and self.room == 61567 then
    local outcome = 0
    -- switch on actor.level
    if actor.level == 1 or actor.level == 2 or actor.level == 3 or actor.level == 4 then
        local outcome = random(1, 8)
    elseif actor.level == 5 or actor.level == 6 or actor.level == 7 or actor.level == 8 then
        local outcome = random(1, 10)
    elseif actor.level == 9 or actor.level == 10 or actor.level == 11 or actor.level == 12 or actor.level == 13 or actor.level == 14 or actor.level == 15 then
        local outcome = random(1, 15)
    else
        local outcome = random(1, 20)
    end
    if outcome == 1 then
        wait(3)
        -- switch on random(1, 3)
        if random(1, 3) == 1 then
            self:say("I tire of your foolishness.")
        elseif random(1, 3) == 2 then
            self:say("You waste my time.")
        else
            self:say("You bore me, " .. tostring(actor.class) .. ".")
        end
        actor:send(tostring(self.name) .. " swiftly loops her chain around your exposed wrist, and yanks!")
        self.room:send_except(actor, tostring(self.name) .. " loops her chain around " .. tostring(actor.name) .. "'s wrist, and yanks it!")
        actor:send("You are sent reeling out of the room!")
        self.room:send_except(actor, tostring(actor.name) .. " is sent reeling out of the room!")
        local dest = 61567 + random(1, 6)
        actor:teleport(get_room(vnum_to_zone(dest), vnum_to_local(dest)))
    end
end