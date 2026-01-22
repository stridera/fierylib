-- Trigger: dragons_health_room_hatch
-- Zone: 586, ID: 4
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #58604

-- Converted from DG Script #58604: dragons_health_room_hatch
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
self.room:send("As " .. tostring(mobiles.template(586, 10).name) .. " turns to walk away from the egg, a crack begins to form...")
wait(3)
self.room:send("The crack continues to grow, branching into hundreds of smaller cracks!")
wait(6)
self.room:send("A talon suddenly breaks through the egg shell!")
wait(3)
self.room:send("Slowly, the head of a bronze dragon pushes through the shell.")
wait(2)
self.room:send("The dragon egg continues to split into pieces.")
wait(2)
self.room:send("A small, bronze dragon emerges from the broken egg shell.")
self.room:send("The tiny dragon looks at " .. tostring(mobiles.template(586, 10).name) .. ".")
world.destroy(self.room:find_actor("dragon-egg"))
wait(3)
self.room:send("The bronze hatchling says, 'Mistress, thank you for protecting me.")
self.room:send("</>You have done a great service to our kind.'")
wait(2)
self.room:send("The bronze dragon looks around itself.")
self.room:send("In a rush of wind, the dragon beats its wings, launching itself into the air.")
wait(6)
self.room:send(tostring(mobiles.template(586, 10).name) .. " watches the hatchling soar through the sky and skim across the ocean's surface.")
wait(2)
self.room:send(tostring(mobiles.template(586, 10).name) .. " beams with joy!")
wait(3)
self.room:send(tostring(mobiles.template(586, 10).name) .. " says, 'I will be forever grateful to you for helping dragonkind.")
self.room:send("</>To show my gratitude, I gift you the Song of the Dragons.'")
wait(3)
self.room:send(tostring(mobiles.template(586, 10).name) .. " sings an ancient Draconic prayer.")
wait(1)
local person = self.people
while person do
    if person:get_quest_stage("dragons_health") == 6 then
        self.room:find_actor("dragonborn"):command("mskillset %person% dragons health")
        person:send("<b:yellow>From the Song of the Dragons you have learned Dragons Health!</>")
        person.name:complete_quest("dragons_health")
    end
    local person = person.next_in_room
end