-- Trigger: jann warrior fight
-- Zone: 489, ID: 27
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48927

-- Converted from DG Script #48927: jann warrior fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if (actor.zone_id == 489) then
    -- Stop combat if fighting another doom mobile
    wait(0.1)
    get_room(11, 0):at(function()
        self.room:find_actor("jann"):heal(1000)
    end)
end
wait(2)
local action = random(1, 10)
if action > 9 then
    -- 10% chance
    self:attack_all()
elseif action > 7 then
    -- 20% chance
    skills.execute(self, "kick", self.fighting)
elseif action > 5 then
    -- 10% chance to dispel magic
    if actor.is_player then
        if (self.zone_id == 489 and self.id == 11) then
            self.room:spawn_object(489, 28)
        else
            self.room:spawn_object(489, 27)
        end
        self:command("recite dispel-scroll " .. tostring(actor.name))
        self:destroy_item("dispel-scroll")
    else
        self:command("roar")
    end
end