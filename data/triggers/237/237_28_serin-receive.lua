-- Trigger: serin-receive
-- Zone: 237, ID: 28
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #23728

-- Converted from DG Script #23728: serin-receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Responding to trigger 23723 after they actually have the items.
-- Tracks each treasure individually via quest vars; on the third real piece,
-- advances and completes the quest with an XP/badge reward.

-- Helper: identify which elven treasure (zone 520) was offered.
-- Returns one of: "boots", "cloak", "ring", "cursed_boots", "cursed_cloak",
-- "cursed_ring", or nil for anything else.
local function identify_treasure(obj)
    if obj.zone_id ~= 520 then
        return nil
    end
    local id = obj.local_id
    if id == 8 then return "boots"
    elseif id == 24 then return "cursed_boots"
    elseif id == 9 then return "cloak"
    elseif id == 26 then return "cursed_cloak"
    elseif id == 1 then return "ring"
    elseif id == 18 then return "cursed_ring"
    end
    return nil
end

if actor.is_npc then
    return true
end
if actor.level > 99 then
    wait(1)
    self:command("eyebrow")
    return true
end

local boots = actor:get_quest_var("sunfire_rescue:boots") or 0
local cloak = actor:get_quest_var("sunfire_rescue:cloak") or 0
local ring = actor:get_quest_var("sunfire_rescue:ring") or 0

if actor:get_has_completed("sunfire_rescue") then
    self:say("You have already helped me.  I am grateful to you.")
    return true
end

if actor:get_quest_stage("sunfire_rescue") ~= 1 then
    self:say("What are you doing?")
    return true
end

local kind = identify_treasure(object)

-- Reject cursed items outright.
if kind == "cursed_boots" then
    self:emote("looks at the boots carefully.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, 'These are the cursed boots.  If you have the real ones,")
    self.room:send("</>please...  These cannot help me at all.  Do you have the real ones?  I need")
    self.room:send("</>them.'")
    return true
elseif kind == "cursed_cloak" then
    self:emote("runs his hands over the cloak quickly.")
    self:say("This is the cursed cloak!")
    self:emote("looks angry.")
    actor:send("shoves " .. tostring(object.shortdesc) .. " back in your face.")
    self.room:send_except(actor, "shoves " .. tostring(object.shortdesc) .. " back in " .. tostring(actor.name) .. "'s face.")
    wait(1)
    self:say("Well?  Do you have the real cloak to give to me?")
    self:emote("taps his foot impatiently.")
    return true
elseif kind == "cursed_ring" then
    self:command("frown " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("What kind of cruel trick is this?")
    wait(1)
    self:say("Well, do you have the real one to give to me?")
    return true
end

-- Real treasures: accept each at most once.
if kind == "boots" then
    if boots == 1 then
        self:say("You have already given me these.")
        return true
    end
    actor:set_quest_var("sunfire_rescue", "boots", 1)
    boots = 1
    wait(2)
    world.destroy(object)
    self:command("smile " .. tostring(actor.name))
    self:say("Thank you.")
    wait(1)
elseif kind == "cloak" then
    if cloak == 1 then
        self:say("You have already given me the cloak.")
        return true
    end
    actor:set_quest_var("sunfire_rescue", "cloak", 1)
    cloak = 1
    wait(2)
    world.destroy(object)
    self:emote("carefully looks at the cloak.")
    self:say("This is it!  Thank you!")
    wait(1)
    self:say("Then I can finally escape....")
elseif kind == "ring" then
    if ring == 1 then
        self:say("You have already given me this ring.")
        return true
    end
    actor:set_quest_var("sunfire_rescue", "ring", 1)
    ring = 1
    wait(2)
    self.room:send("Looking at the ring, the prisoner looks overwhelmed with emotion.")
    self:say("Escape is so close I can feel it!")
    world.destroy(object)
else
    self:say("This isnt going to help me!")
    self:command("roll")
    return true
end

-- Has the player now turned in all three treasures?
local total = boots + cloak + ring
if total < 3 then
    wait(1)
    self:say("Do you have the other treasures of my people?")
    return true
end

-- All three -- complete the quest.
wait(2)
self:emote("slips his feet out of the shackles and wears the boots.")
wait(2)
self:emote("unshackles his arms and wears the cloak on his shoulders.")
wait(2)
self.room:send("Looking hesitant, the prisoner slowly slides the ring onto his finger.")
actor:advance_quest("sunfire_rescue")
self.room:spawn_object(237, 16)
self:destroy_item("all.elven")
wait(3)
self:emote("vanishes from sight.")

-- The badge reward is level 50, but the players have to be 70 or so
-- to handle the boots, cloak etc anyway.
local expcap
if actor.level < 85 then
    expcap = actor.level
else
    expcap = 85
end

local expmod
if expcap < 9 then
    expmod = (((expcap * expcap) + expcap) / 2) * 55
elseif expcap < 17 then
    expmod = 440 + ((expcap - 8) * 125)
elseif expcap < 25 then
    expmod = 1440 + ((expcap - 16) * 175)
elseif expcap < 34 then
    expmod = 2840 + ((expcap - 24) * 225)
elseif expcap < 49 then
    expmod = 4640 + ((expcap - 32) * 250)
elseif expcap < 90 then
    expmod = 8640 + ((expcap - 48) * 300)
else
    expmod = 20940 + ((expcap - 89) * 600)
end

-- Adjust exp award by class so all classes receive the same proportionate amount.
if actor.class == "Warrior" or actor.class == "Berserker" then
    -- 110% of standard
    expmod = expmod + (expmod / 10)
elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
    -- 115% of standard
    expmod = expmod + ((expmod * 2) / 15)
elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
    -- 120% of standard
    expmod = expmod + (expmod / 5)
elseif actor.class == "Necromancer" or actor.class == "Monk" then
    -- 130% of standard
    expmod = expmod + ((expmod * 2) / 5)
end

actor:send("<b:yellow>You gain experience!</>")
local setexp = expmod * 10
for _ = 1, 10 do
    actor:award_exp(setexp)
end
actor:complete_quest("sunfire_rescue")
wait(2)
actor:send(tostring(self.name) .. " whispers to you, 'Thank you for your help!  Please wear this badge as a token of my respect.'")
self:command("give badge " .. tostring(actor.name))
wait(2)
self.room:send("A voice softly echos, 'Good-bye...'")
world.destroy(self.room:find_actor("serin"))
return true
