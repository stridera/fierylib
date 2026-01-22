-- Trigger: mild -> Ursa
-- Zone: 625, ID: 7
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #62507

-- Converted from DG Script #62507: mild -> Ursa
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local mode = random(1, 10)
if mode > 7 then
    local actor = actor.name
    self.room:send_except(self, "<b:yellow>" .. tostring(self.name) .. " falls to his knees, letting out a disturbing ROAR!!</>")
    wait(2)
    self.room:send_except(self, "<b:yellow>" .. tostring(self.name) .. " stretches to twice his normal size!</>")
    wait(2)
    self.room:send_except(self, "<b:yellow>" .. tostring(self.name) .. " contorts into a wearbear!</>")
    wait(1)
    world.destroy(self)
    self.room:spawn_mobile(625, 7)
    self.room:find_actor("ursa"):damage(200)
    if actor.id ~= 62506 then
        self.room:find_actor("ursa"):command("kill %actor%")
    end
end