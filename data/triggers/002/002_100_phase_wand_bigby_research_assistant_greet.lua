-- Trigger: phase wand bigby research assistant greet
-- Zone: 2, ID: 100
-- Type: MOB, Flags: GREET_ALL
--
-- Bigby's research assistant (the entry-point for every phase wand quest).
-- On greet, drops invisibility, then for any of the four wand quests:
--  - flags the player as "greeted" (per quest var) so receive can advance,
--  - offers an upgrade if the player is wielding/holding a basic wand at
--    pre-craft stage,
--  - prompts about gem progress if the player is mid-craft (stage 2),
--  - reminds the player to come back for higher tiers (stage > 2).
--
-- TODO(parity): `actor:has_equipped("300")` / `actor:has_item("300")`
-- pass legacy 5-digit vnums as strings; once the runtime exposes a
-- (zone, id) form for these checks, rewrite to has_equipped(2, 100) etc.
if self:has_effect(Effect.Invisible) then
    self:command("vis")
end
wait(2)
local air = actor:get_quest_stage("air_wand") or 0
local fire = actor:get_quest_stage("fire_wand") or 0
local ice = actor:get_quest_stage("ice_wand") or 0
local acid = actor:get_quest_stage("acid_wand") or 0
local airgreet = actor:get_quest_var("air_wand:greet")
local firegreet = actor:get_quest_var("fire_wand:greet")
local icegreet = actor:get_quest_var("ice_wand:greet")
local acidgreet = actor:get_quest_var("acid_wand:greet")
if air > 2 or fire > 2 or ice > 2 or acid > 2 or airgreet or firegreet or icegreet or acidgreet then
    self:say("Ah, welcome back " .. tostring(actor.name) .. "!")
    wait(2)
end
local class = actor.class or ""
if not (string.find(class, "sorcerer") or string.find(class, "pyromancer")
        or string.find(class, "cryomancer") or string.find(class, "illusionist")
        or string.find(class, "necromancer")) then
    return
end
if actor.level < 10 then return end

local offer, continue = false, false
local function check(stage, q, wand_id)
    if (actor:has_equipped(wand_id) or actor:has_item(wand_id)) and stage < 2 then
        if stage == 0 then
            actor:start_quest(q)
        end
        actor:set_quest_var(q, "greet", 1)
        offer = true
    elseif stage == 2 then
        continue = true
    end
end
check(air, "air_wand", "300")
check(fire, "fire_wand", "310")
check(ice, "ice_wand", "320")
check(acid, "acid_wand", "330")

if continue then
    self:say("Have you been practicing and looking for the gems you need?")
    wait(2)
end
if offer then
    self.room:send(tostring(self.name) .. " says, 'I see you have a new elemental wand!  I can <b:cyan>upgrade</> basic wands.'")
    wait(2)
end
if air > 2 or fire > 2 or ice > 2 or acid > 2 then
    self.room:send(tostring(self.name) .. " says, 'If you want to upgrade a wand again, I can point you in the right direction.  Just tell me which energy type you want to work on: <green>acid</>, <b:white>air</>, <red>fire</>, or <b:blue>ice</>.'")
end
