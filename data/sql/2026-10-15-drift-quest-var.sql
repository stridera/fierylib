-- Trigger fixes (prod drift): the three prod rows whose body drifted from the repo (Muditor header comment; 120:3 also capitalised class names) get the quest-var nil-safety rewrites of 2026-10-15-quest-var-nil.sql and 2026-10-15-quest-var-arith.sql, plus (120:3) the lowercase class names of 7fbb74a, keeping the prod header comments. The r11/r11b/word-boundary changes do not touch these rows.
--
-- Apply to prod only. Guarded on the PROD body md5, so a row edited again in Muditor is left alone;
-- idempotent: a row already holding the new body matches no guard on a rerun.
-- Keyed by the composite primary key (zone_id, id).

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/120/120_03_druid_receive.lua (prod body: header comment kept; quest-var nil rewrites, lowercase class names ported from git)
  (120, 3, $trig$-- Trigger: Druid receive
-- Zone: 120, ID: 3
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #12003
--
-- The druid accepts a liquid container, and if the player is at a Rhell tree
-- room and the contents match the tree's preferred drink, advances the
-- twisted_sorrow quest. Five trees, five offerings; on the fifth, the druid
-- gifts the sleeves-of-sorrow and the player completes the quest.
local stage = actor:get_quest_stage("twisted_sorrow")

-- Quest already complete: politely refuse.
if stage > 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.8)
    self:say("No further offerings are necessary.")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Quest not yet started: refuse with confusion.
if stage ~= 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.8)
    self:say("Why do you give me this?")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Stage 1: must be a liquid container.
if object.type ~= "DRINKCONTAINER" then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.4)
    self:say("This is not a liquid container.")
    wait(0.4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Druid's home grove (no tree): redirect player.
if self.room == 12015 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.4)
    self:say("Let us move to one of the mighty Rhells first, friend.")
    wait(0.4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Empty container: refuse.
if object.val1 == 0 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.4)
    self:emote("peers into " .. object.shortdesc .. ".")
    wait(0.4)
    self:say("This won't do at all!  It's empty.")
    wait(0.4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- This tree already satisfied: refuse.
if (actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. tostring(self.room)) or 0) == 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.4)
    self:say("This tree is already satisfied, my friend.")
    wait(0.4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Otherwise: druid consumes the offering and may advance the quest.
wait(1)
self:emote("peers into " .. object.shortdesc .. ".")
wait(2)
self:command("nod")
wait(2)
self:command("kneel")
self:emote("places his hands on the mighty Rhell's roots.")
wait(5)
self:emote("continues to kneel, making no sound.")
wait(7)
self:command("stand")

-- Match liquid type to tree (object.val2 = liquid type code).
local success = false
if self.room == 12016 and object.val2 == 11 then            -- Tree of Luck: tea
    success = true
elseif self.room == 12017 and object.val2 > 0 and object.val2 < 5 then  -- Reverence: alcohol
    success = true
elseif self.room == 12018 and object.val2 == 0 then          -- Self-reliance: water
    success = true
elseif self.room == 12014 and object.val2 == 12 then         -- Nimbleness: coffee
    success = true
elseif self.room == 12046 and object.val2 == 10 then         -- Kindness: milk
    success = true
end

self.room:send(self.name .. " carefully pours out " .. object.shortdesc .. " onto the Rhell's roots.")
wait(0.1)
world.destroy(object)
wait(0.8)

if not success then
    self:command("sigh")
    wait(0.8)
    self:say("The tree is not responding.")
    wait(1)
    self:say("I fear it has little liking for that drink.")
    return false
end

local num_trees = 1 + (actor:get_quest_var("twisted_sorrow:num_trees") or 0)
actor:set_quest_var("twisted_sorrow", "num_trees", num_trees)
actor:set_quest_var("twisted_sorrow", "satisfied_tree:" .. tostring(self.room), 1)
self.room:send("A deep throbbing hum is emanating from the ground.")
wait(3)
self.room:send("The hum gets louder and louder, causing twigs and leaves to dance upon the ground!")
self.room:send("It is overwhelming, yet soothing.")
wait(5)
self.room:send("The hum fades slowly away, and all is quiet again.")
wait(3)
self:command("smile")
wait(2)

if num_trees < 4 then
    self:say("You have done this tree a great service.")
elseif num_trees == 4 then
    self:say("I sense that yet another tree waits in loneliness.")
    wait(1)
    self:say("There can be no peace until it, too, is satisfied.")
elseif num_trees == 5 then
    self:say("Excellent, my friend!  The trees are satisfied.")
    wait(0.8)
    self:say("Please take this gift on their behalf.")
    wait(0.8)
    self.room:spawn_object(120, 18)
    self:command("give sleeves-sorrow " .. actor.name)
    wait(0.4)
    self:emote("walks away quietly.")
    actor:complete_quest("twisted_sorrow")

    -- Compute experience award scaled by capped level.
    local expcap
    if actor.level < 10 then
        expcap = actor.level
    else
        expcap = 10
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

    -- Class scaling so all classes receive the same proportionate amount.
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = expmod + (expmod / 10)                       -- 110%
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = expmod + ((expmod * 2) / 15)                 -- 115%
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = expmod + (expmod / 5)                        -- 120%
    elseif actor.class == "necromancer" or actor.class == "monk" then
        expmod = expmod + ((expmod * 2) / 5)                  -- 130%
    end

    actor:send("<b:yellow>You gain experience!</>")
    -- Legacy DG awarded expmod ten times in a loop; preserved for parity.
    for _ = 1, 10 do
        actor:award_exp(expmod)
    end
    self:teleport(get_room(120, 15))
end

return false$trig$, '6b4a5f0ae0e84e7db800d52cdc564b2a'),
  -- data/triggers/625/625_33_rhell_merchant_receive_4-3.lua (prod body: header comment kept; quest-var nil rewrites ported from git)
  (625, 33, $trig$-- Trigger: Rhell Merchant receive 4-3
-- Zone: 625, ID: 33
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62533

-- Converted from DG Script #62533: Rhell Merchant receive 4-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 4 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 3 then
        -- for path 3, the merchant asks for an anvil
        -- note - the anvil is extremely heavy but must be picked up and given to the merchant to complete the quest; it cannot just be dragged to him.
        if object.type == "DRINKCONTAINER" then
            if object.val2 == 10 then
                wait(0.2)
                world.destroy(object)
                actor:advance_quest("ursa_quest")
                wait(1)
                self:say("Excellent.  Now to crush this ring...")
                self:emote("drops the ring of stolen life.")
                self:emote("wields the Golden Druidstaff.")
                wait(3)
                self.room:send("<b:green>" .. tostring(self.name) .. " </><green>SMACKS<b:green> the ring, which </><green>bounces<b:green> and lands lightly back on the dirt.</>")
                wait(3)
                self:command("blink")
                wait(3)
                self.room:send("<b:green>" .. tostring(self.name) .. " </><green>SMACKS<b:green> the ring, which </><green>bounces<b:green> and lands lightly back on the dirt.</>")
                wait(3)
                self:command("grumble")
                self.room:send(tostring(self.name) .. " says, This isn't going to work.  Off the Great Road is a lumber mill.  Their smith has an anvil that will do perfectly.")
            else
                wait(0.2)
                self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
                wait(1)
                self:say("Good, now put some milk in this, and bring it to me again.")
                self:command("give " .. tostring(object) .. " " .. tostring(actor) .. ".")
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I'm not sure how one gets milk out of this.")
        end
    end
end
return _return_value$trig$, '6164a3734a5f8fcb971d97ee17f18bd1'),
  -- data/triggers/625/625_35_rhell_merchant_receive_5-2.lua (prod body: header comment kept; quest-var nil rewrites ported from git)
  (625, 35, $trig$-- Trigger: Rhell Merchant receive 5-2
-- Zone: 625, ID: 35
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62535

-- Converted from DG Script #62535: Rhell Merchant receive 5-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 5 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        -- extra step for evil path: merchant drinks and asks for a big bag - either a saddle or the tattered bag will work
        if object.type == "DRINKCONTAINER" then
            wait(1)
            self:command("drink " .. tostring(object))
            wait(1)
            if object.val2 == 7 then
                self:say("This is the good stuff!")
                actor:advance_quest("ursa_quest")
                wait(1)
                self:command("drink " .. tostring(object))
                wait(1)
                self:say("Okay...  Now I'm ready.  All I need now is something to kill myself in.")
                wait(1)
                self:emote("looks around for a makeshift sarcophagus.")
                wait(2)
                self:say("Do you have something big enough for me to fit in?  Like a big box or a bag or something?")
            else
                self:command("spit " .. tostring(actor.name))
                wait(1)
                self:say("This isn't going to cut it, kid.")
                wait(2)
                self:say("Got anything stronger?")
                self:command("give " .. tostring(object) .. " " .. tostring(actor.name))
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I'm looking for a drink.  A strong one!")
        end
    end
end
return _return_value$trig$, '1dfa9cfe6bb6eed8e588c992fd5e08fb')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
