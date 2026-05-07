-- Trigger: dragons_health_room_hatch
-- Zone: 586, ID: 4
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #58604
-- Cinematic: hatches the bronze dragon egg, plays the gratitude scene from
-- Myorrhed (mob 586:10), and grants the Dragons Health prayer to every player
-- in the room who has reached quest stage 6 (final hoard delivered).

local myorrhed_name = mobiles.template(586, 10).name
wait(2)
self.room:send("As " .. tostring(myorrhed_name) .. " turns to walk away from the egg, a crack begins to form...")
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
self.room:send("The tiny dragon looks at " .. tostring(myorrhed_name) .. ".")
local egg = self.room:find_object("dragon-egg")
if egg then
    world.destroy(egg)
end
wait(3)
self.room:send("The bronze hatchling says, 'Mistress, thank you for protecting me.")
self.room:send("</>You have done a great service to our kind.'")
wait(2)
self.room:send("The bronze dragon looks around itself.")
self.room:send("In a rush of wind, the dragon beats its wings, launching itself into the air.")
wait(6)
self.room:send(tostring(myorrhed_name) .. " watches the hatchling soar through the sky and skim across the ocean's surface.")
wait(2)
self.room:send(tostring(myorrhed_name) .. " beams with joy!")
wait(3)
self.room:send(tostring(myorrhed_name) .. " says, 'I will be forever grateful to you for helping dragonkind.")
self.room:send("</>To show my gratitude, I gift you the Song of the Dragons.'")
wait(3)
self.room:send(tostring(myorrhed_name) .. " sings an ancient Draconic prayer.")
wait(1)
-- TODO: granting the Dragons Health skill needs a real Lua API. The legacy
-- script invoked the imm command `mskillset` via a hidden dragonborn mob; no
-- equivalent binding exists yet, so we only mark the quest complete here.
for _, person in ipairs(self.room.actors) do
    if person.is_player and person:get_quest_stage("dragons_health") == 6 then
        person:send("<b:yellow>From the Song of the Dragons you have learned Dragons Health!</>")
        person:complete_quest("dragons_health")
    end
end