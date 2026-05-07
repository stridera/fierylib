-- Trigger: mild -> Ursa
-- Zone: 625, ID: 7
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #62507

-- Converted from DG Script #62507: mild -> Ursa
-- Original: MOB trigger, flags: FIGHT, probability: 100%
--
-- The mild merchant (625, 6) loses control mid-combat and
-- transforms into Ursa (625, 7). 30% chance per FIGHT tick.
local mode = random(1, 10)
if mode > 7 then
    local target_name = actor.name
    local target_is_merchant = (actor.zone_id == 625 and actor.local_id == 6)
    self.room:send_except(self, "<b:yellow>" .. tostring(self.name) .. " falls to his knees, letting out a disturbing ROAR!!</>")
    wait(2)
    self.room:send_except(self, "<b:yellow>" .. tostring(self.name) .. " stretches to twice his normal size!</>")
    wait(2)
    self.room:send_except(self, "<b:yellow>" .. tostring(self.name) .. " contorts into a wearbear!</>")
    wait(1)
    world.destroy(self)
    self.room:spawn_mobile(625, 7)
    local ursa = self.room:find_actor("ursa")
    ursa:damage(200)
    if not target_is_merchant then
        ursa:command("kill " .. tostring(target_name))
    end
end
