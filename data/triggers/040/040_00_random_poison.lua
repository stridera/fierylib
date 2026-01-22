-- Trigger: Random_Poison
-- Zone: 40, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #4000

-- Converted from DG Script #4000: Random_Poison
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor.level < 100 then
    wait(1)
    actor:damage(5)  -- type: poison
    if damage_dealt ~= 0 then
        actor:send("The tainted air fills your lungs with its cryptic essence. (<green>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " begins to appear ill and faint. (<green>" .. tostring(damage_dealt) .. "</>)")
        wait(4)
        actor:damage(15)  -- type: poison
        if damage_dealt ~= 0 then
            actor:send("The poison rips into your body corrupting your blood. (<green>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(actor, tostring(actor.name) .. " bends over rasping and grabbing " .. tostring(actor.possessive) .. " chest in pain. (<green>" .. tostring(damage_dealt) .. "</>)")
            wait(30)
            actor:damage(12)  -- type: poison
            if damage_dealt ~= 0 then
                actor:send("The poison rips into your body corrupting your blood. (<green>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(actor, tostring(actor.name) .. " bends over rasping and grabbing " .. tostring(actor.possessive) .. " chest in pain. (<green>" .. tostring(damage_dealt) .. "</>)")
                wait(30)
                actor:damage(15)  -- type: poison
                if damage_dealt ~= 0 then
                    actor:send("The poison rips into your body corrupting your blood. (<green>" .. tostring(damage_dealt) .. "</>)")
                    self.room:send_except(actor, tostring(actor.name) .. " bends over rasping and grabbing " .. tostring(actor.possessive) .. " chest in pain. (<green>" .. tostring(damage_dealt) .. "</>)")
                end
            end
        end
    end
end