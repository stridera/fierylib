-- Trigger: spectral-wife_receive
-- Zone: 470, ID: 2
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #47002

-- Converted from DG Script #47002: spectral-wife_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- React when the broken wedding ring (470,19) is given to the spectral wife.
if object.zone_id == 470 and object.local_id == 19 then
    if actor.is_player then
        if actor.level > 99 then
            wait(1)
            actor:send(tostring(self.name) .. " says, '<b:yellow>Silly immortal, tricks are for kids!</>'")
            self:command("give broken-wedding-ring " .. tostring(actor.name))
        else
            wait(1)
            self.room:send(tostring(self.name) .. " says, '<b:yellow>Oh my poor husband!  What have you done to him?!?</>'")
            self:command("remove ethereal-ring-undead")
            self:command("unlock door south")
            self:command("open door south")
            self.room:send_except(actor, tostring(self.name) .. " rears back in rage and " .. tostring(actor.name) .. " stumbles towards the south!")
            actor:send(tostring(self.name) .. " rears back in rage and you stumble towards the south!")
            actor:move("south")
            self:command("stand")
            self:move("south")
            self:command("close door north")
            self:command("lock door north")
            self:command("close folding-doors east")
            self:command("wear ethereal-ring-undead")
            self.room:send(tostring(self.name) .. " screams in tremendous rage, '<b:yellow>I will avenge my husband's death!!</>'")
            combat.engage(actor)
        end
    end
end