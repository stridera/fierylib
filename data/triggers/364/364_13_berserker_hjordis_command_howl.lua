-- Trigger: berserker_hjordis_command_howl
-- Zone: 364, ID: 13
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- On stage 3, the player howls and the Spirits reveal a randomly chosen
-- Wild Hunt quarry (one of four predator mobs across the world). Stores the
-- target ID in `berserker_subclass:target` and advances the quest.
--
-- Each target is encoded as a single legacy id (zone*100 + local) so it can
-- be compared cheaply in 364_14 / 364_15 / 364_20 against `self.id`.
--
-- Original DG Script: #36413

if cmd ~= "howl" then
    return true
end
if actor:get_quest_stage("berserker_subclass") ~= 3 then
    return true
end

actor:advance_quest("berserker_subclass")
actor:send("You raise your voice in a mighty howl to the Spirits!")
self.room:send_except(actor, tostring(actor.name) .. " raises " .. tostring(hisher) .. " voice in a mighty howl to the Spirits!")
wait(2)

-- TODO(parity): targets are stored as legacy 5-digit ids (zone*100 + local).
-- This matches the comparisons in 364_14/15/20 which do `self.id`. When the
-- runtime exposes `self.legacy_id` consistently this can stay; otherwise it
-- needs to switch to (zone, local) tuples.
local QUARRIES = {
    { id = 16105, place = "a desert cave"           },
    { id = 16310, place = "some forested highlands" },
    { id = 20311, place = "a vast plain"            },
    { id = 55220, place = "the frozen tundra"       },
}
local pick = QUARRIES[random(1, #QUARRIES)]
local target = pick.id
local place = pick.place

actor:send(tostring(self.name) .. " throws her head back and howls along with you!")
self.room:send_except(actor, tostring(self.name) .. " throws her head back and howls along with " .. tostring(actor.name) .. "!")
wait(2)
actor:set_quest_var("berserker_subclass", "target", target)
local quarry_zone = math.floor(target / 100)
local quarry_local = target % 100
local quarry_name = mobiles.template(quarry_zone, quarry_local).name
actor:send("The Spirits reveal to you a vision of <b:yellow>" .. tostring(quarry_name) .. "</>!")
actor:send("You see it is in <b:yellow>" .. tostring(place) .. "</>!")
wait(6)
actor:send(tostring(self.name) .. " says, 'The Spirits have spoken!'")
wait(2)
actor:send(tostring(self.name) .. " says, 'Find the beast of your Wild Hunt and join our ranks.  Remember, this quest must be undertaken <b:red>ALONE</>.  If you are grouped when you fight your prey, there will be consequences!'")
return true