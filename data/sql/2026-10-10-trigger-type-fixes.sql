-- Trigger type/skill fixes: object.type is compared against the strings the Rust runtime returns (uppercased ObjectType Debug name: DRINKCONTAINER, LIGHT, FOOD), not the legacy "LIQCONTAINER" / "LIQ CONTAINER" / lowercase spellings; 185_23 grants group heal at 1000 (legacy mskillset max proficiency) instead of 100.
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/120/120_03_druid_receive.lua
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
    wait(8)
    self:say("No further offerings are necessary.")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Quest not yet started: refuse with confusion.
if stage ~= 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(8)
    self:say("Why do you give me this?")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Stage 1: must be a liquid container.
if object.type ~= "DRINKCONTAINER" then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(4)
    self:say("This is not a liquid container.")
    wait(4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Druid's home grove (no tree): redirect player.
if self.room == 12015 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(4)
    self:say("Let us move to one of the mighty Rhells first, friend.")
    wait(4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Empty container: refuse.
if object.val1 == 0 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(4)
    self:emote("peers into " .. object.shortdesc .. ".")
    wait(4)
    self:say("This won't do at all!  It's empty.")
    wait(4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- This tree already satisfied: refuse.
if actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. tostring(self.room)) == 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(4)
    self:say("This tree is already satisfied, my friend.")
    wait(4)
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
wait(1)
world.destroy(object)
wait(8)

if not success then
    self:command("sigh")
    wait(8)
    self:say("The tree is not responding.")
    wait(1)
    self:say("I fear it has little liking for that drink.")
    return false
end

local num_trees = 1 + actor:get_quest_var("twisted_sorrow:num_trees")
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
    wait(8)
    self:say("Please take this gift on their behalf.")
    wait(8)
    self.room:spawn_object(120, 18)
    self:command("give sleeves-sorrow " .. actor.name)
    wait(4)
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
    if actor.class == "Warrior" or actor.class == "Berserker" then
        expmod = expmod + (expmod / 10)                       -- 110%
    elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
        expmod = expmod + ((expmod * 2) / 15)                 -- 115%
    elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
        expmod = expmod + (expmod / 5)                        -- 120%
    elseif actor.class == "Necromancer" or actor.class == "Monk" then
        expmod = expmod + ((expmod * 2) / 5)                  -- 130%
    end

    actor:send("<b:yellow>You gain experience!</>")
    -- Legacy DG awarded expmod ten times in a loop; preserved for parity.
    for _ = 1, 10 do
        actor:award_exp(expmod)
    end
    self:teleport(get_room(120, 15))
end

return false$trig$),
  -- data/triggers/185/185_23_group_heal_injured_give.lua
  (185, 23, $trig$-- Trigger: group_heal_injured_give
-- Zone: 185, ID: 23
-- Type: OBJECT, Flags: GIVE
--
-- Stage 6 of group_heal: player gives a medical packet (185,21) to an
-- injured/sick/wounded NPC. Each unique recipient (tracked by quest var
-- "group_heal:<zone>_<id>") increments total. After 5 deliveries, the
-- player learns the Group Heal spell.
--
-- Eligible targets (legacy vnums -> (zone, id)):
--   18506 -> (185,  6)   abbey injured
--   46414 -> (464, 14)
--   43020 -> (430, 20)
--   12513 -> (125, 13)
--   36103 -> (361,  3)
--   58803 -> (588,  3)
--   30054 -> (300, 54)
-- Refused targets (Lirne and one other):
--   62506 -> (625,  6)
--   53450 -> (534, 50)
--
-- TODO(parity): legacy 5-digit vnums above need verification.
-- The reward (legacy `mskillset %actor% group heal`) is the typed
-- actor:set_skill(name, proficiency) binding; the script-origin gate refuses
-- the staff `mskillset` command from a script.

if actor:get_quest_stage("group_heal") ~= 6 then
    return true
end

if victim.is_player then
    return true
end

local function vnum_match(zone, id)
    return victim.zone_id == zone and victim.local_id == id
end

local key = "group_heal:" .. tostring(victim.zone_id) .. "_" .. tostring(victim.local_id)
if actor:get_quest_var(key) then
    actor:send("you have already helped " .. tostring(victim.name))
    return true
end

local eligible_recipients = {
    {185,  6}, {464, 14}, {430, 20}, {125, 13},
    {361,  3}, {588,  3}, {300, 54},
}
local refused_recipients = { {625, 6}, {534, 50} }

local is_eligible = false
for _, t in ipairs(eligible_recipients) do
    if vnum_match(t[1], t[2]) then is_eligible = true; break end
end
local is_refused = false
for _, t in ipairs(refused_recipients) do
    if vnum_match(t[1], t[2]) then is_refused = true; break end
end

if is_eligible then
    actor:set_quest_var("group_heal", tostring(victim.zone_id) .. "_" .. tostring(victim.local_id), 1)
    local heal = (actor:get_quest_var("group_heal:total") or 0) + 1
    actor:set_quest_var("group_heal", "total", heal)

    actor:send("You give " .. tostring(self.shortdesc) .. " to " .. tostring(victim.name) .. " and apply the medicine to " .. tostring(victim.himher) .. ".")
    wait(1)
    self.room:send(tostring(victim.name) .. "'s wounds begin to heal as they consume the magical feast.")
    wait(2)

    -- Animal recipients (46414/36103) get a "nuzzle" rather than a thanks/bow.
    if vnum_match(464, 14) or vnum_match(361, 3) then
        victim:command("nuzzle " .. tostring(actor.name))
        wait(1)
        self.room:send(tostring(victim.name) .. " turns and departs.")
    else
        self.room:send(tostring(victim.name) .. " says, 'Thank you so much for coming to my aid!'")
        wait(1)
        self.room:send(tostring(victim.name) .. " bows and departs.")
    end

    if heal >= 5 then
        actor:set_skill("group heal", 1000)
        world.destroy(victim)
        wait(1)
        actor:send("The miraculous power of St. George washes over you!")
        actor:send("The appropriate prayers to beseech the gods for group heal well up in your soul.")
        actor:complete_quest("group_heal")
        actor:send("<b:white>You have learned Group Heal</>!")
    else
        world.destroy(victim)
    end
    world.destroy(self)
elseif is_refused then
    wait(1)
    actor:send("It is not possible to help " .. tostring(victim.name) .. ".")
else
    wait(1)
    actor:send(tostring(victim.name) .. " does not appear to be hurt.")
end

return true$trig$),
  -- data/triggers/390/390_07_flood_spirits_receive.lua
  (390, 7, $trig$-- Trigger: flood_spirits_receive
-- Zone: 390, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #39007
--
-- A spirit (or the Lady herself) receives an item from the Envoy:
--   - Lady (39012) receiving heart-ocean (390:0) at stage 2 fires the
--     flood cataclysm and completes the quest.
--   - Phoenix (39014) wants the phoenix feather (584:1, legacy 58401).
--   - Greengreen (39016) eats foods until val0 totals >= 200; refuses
--     repeats keyed by (zone_id, local_id).
--   - Black Lake (39019) wants an eternal light (val1 == -1).
-- Anything else is refused. On stage advance, all eight water flags are
-- rechecked and `advance_quest` fires if complete.
--
-- TODO: legacy vnum dispatch (self.id == 39012..39019, object.id == 39000,
-- object.id == 58401). Replace with (zone, local_id) once confirmed.
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("flood")
-- switch on self.id
if stage == 2 then
    if object.id == 39000 then
        if self.id == 39012 then
            self:destroy_item("heart-ocean")
            wait(1)
            self.room:send(tostring(self.name) .. " screams, 'LET THE SIEGE BEGIN!!'")
            -- (empty room echo)
            self.room:send("The ocean erupts in a violent frenzy.")
            wait(3)
            self.room:send("Massive waves begin to crest and smash against the settlement gate.")
            self.room:send(tostring(self.name) .. " screams with reckless abandon like the most terrifying of barbarian berserkers.")
            wait(6)
            self.room:send("Spirits rise up through the churning ocean.")
            self.room:send("Giant black waves and enormous icebergs assault the rocky shores!")
            self.room:send(tostring(self.name) .. " wails, 'YOU SHALL DIE FOR STEALING FROM ME.'")
            wait(7)
            self.room:send("The nine Great Waters pull away from the settlement's borders as if granting a moment of reprieve.")
            wait(4)
            self.room:send("The ocean's level drops as the waters quickly rush away.")
            wait(4)
            self.room:send("On the horizon, a titanic wall of water rises up like a hellish behemoth.")
            wait(2)
            self.room:send("The gargantuan tsunami rushes toward the rocks and SMASHES through the settlement gate!")
            wait(6)
            self.room:send("Screaming voices are instantly snuffed out.")
            self.room:send("Dozens of bodies smash into the rocks and shatter like glass as the tsunami obliterates the settlement.")
            wait(8)
            self.room:send("As quickly as it began, the flood waters recede leaving nothing but chilling silence and carnage in its wake.")
            wait(6)
            self.room:send("The Lady of the Sea vanishes beneath the waves.")
            run_room_trigger(390, 13)
            wait(4)
            actor:send("A watery voice floats past your ear:")
            actor:send("'Never forget what you have witnessed here today.'")
            wait(1)
            actor:send("It whispers the eldritch formula for summoning such a cataclysm again.")
            actor:complete_quest("flood")
            skills.set_level(actor.name, "flood", 100)
            actor:send("<b:blue>You have learned Flood.</>")
            wait(2)
            actor:send("'Thank you for the role you played.'")
            world.destroy(self)
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This is not my heart!")
            wait(1)
            self.room:send(tostring(self.name) .. " bellows, 'GIVE IT BACK OR I WILL DESTROY YOU.'")
        end
    end
elseif self.id == 39014 then
    local color = "&6"
    if stage == 1 then
        if object.id == 58401 then
            self:destroy_item("feather")
            wait(1)
            self.room:send(tostring(self.name) .. " submerges the feather in the steaming water.")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I can entrust the safety of the springs to this</>")
            self.room:send("</>" .. tostring(color) .. "feather's magical energy for a short while.  I will join the ocean's crusade.'</>")
            actor:set_quest_var("flood", "water2", 1)
            wait(2)
            self.room:send(tostring(color) .. "With a mighty cry " .. tostring(self.name) .. " dives back into the water.</>")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This will not keep my spring sufficiently warm.'</>")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I need nothing from you.'</>")
    end
elseif self.id == 39016 then
    local color = "&2"
    if stage == 1 then
        if object.type == "FOOD" then
            if actor:get_quest_var("flood:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
                wait(2)
                self.room:send(tostring(self.name) .. " wails in anger as she thrashes about!")
                self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the sea!")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have already eaten that!  I refuse to eat it again!'</>")
            else
                actor:set_quest_var("flood", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
                local full = actor:get_quest_var("flood:hunger")
                local hunger = (full + object.val0)
                actor:set_quest_var("flood", "hunger", hunger)
                self:destroy_item("food")
                self.room:send(tostring(self.name) .. " greedily devours " .. tostring(object.shortdesc) .. ".")
                if hunger >= 200 then
                    wait(2)
                    self.room:send(tostring(self.name) .. " licks her massive chops.</>")
                    wait(1)
                    self:command("burp")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'The dead within me are sated.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'For now.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'We will join with the ocean in her revenge.'")
                    wait(1)
                    self.room:send(tostring(color) .. tostring(self.name) .. " sinks beneath the waves.</>")
                    actor:set_quest_var("flood", "water4", 1)
                else
                    wait(2)
                    self.room:send(tostring(self.name) .. " licks her massive chops.")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Bring me more!'</>")
                    return _return_value
                end
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This is not food!!'</>")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I want nothing from you.'</>")
    end
elseif self.id == 39019 then
    local color = "&9&b"
    if stage == 1 then
        if object.type == "LIGHT" then
            if object.val1 == -1 then
                actor:set_quest_var("flood", "water7", 1)
                wait(2)
                self.room:send(tostring(self.name) .. " grins with a sick malevolence.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I'll take great joy in this!'</>")
                wait(2)
                self.room:send(tostring(self.name) .. " plunges the light into the depths of the Black Lake.")
                world.destroy(object)
                wait(3)
                self.room:send("The light twinkles for a few moments as it sinks into the darkness before fading forever.")
                wait(4)
                self:command("laugh")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Intoxicating.'</>")
                wait(2)
                self.room:send(tostring(self.name) .. " says," .. tostring(color) .. " 'I will join the Arabel Ocean with pleasure.'</>")
                self:command("bow")
                wait(2)
                self.room:send(tostring(color) .. tostring(self.name) .. " splashes back into the inky blackness of the lake.</>")
            else
                _return_value = true
                self.room:send(tostring(self.name) .. " scoffs.")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This wouldn't glow forever even before I consume it.'</>")
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This isn't even a light!'</>")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'You have nothing to offer me.'</>")
    end
else
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have no need for this.'</>")
end
if stage == 1 then
    local water1 = actor:get_quest_var("flood:water1")
    local water2 = actor:get_quest_var("flood:water2")
    local water3 = actor:get_quest_var("flood:water3")
    local water4 = actor:get_quest_var("flood:water4")
    local water5 = actor:get_quest_var("flood:water5")
    local water6 = actor:get_quest_var("flood:water6")
    local water7 = actor:get_quest_var("flood:water7")
    local water8 = actor:get_quest_var("flood:water8")
    if water1 and water2 and water3 and water4 and water5 and water6 and water7 and water8 then
        actor:advance_quest("flood")
        wait(1)
        actor:send("<b:blue>You have garnered the support of all the great waters!</>")
    end
end
world.destroy(self)
return _return_value$trig$),
  -- data/triggers/490/490_11_whisky_trig.lua
  (490, 11, $trig$-- Trigger: whisky_trig
-- Zone: 490, ID: 11
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49011

-- Converted from DG Script #49011: whisky_trig
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
if object.type == "DRINKCONTAINER" then
    if object.val1 == 0 then
        self:say("An empty container?  How generous.")
    elseif object.val2 ~= 5 then
        self:say("Whisky is what I wanted!")
    else
        self:say("Thanks " .. tostring(actor.name) .. " and here is your ladder")
        self.room:spawn_object(490, 41)
        self:command("give ladder " .. tostring(actor.name))
    end
end$trig$),
  -- data/triggers/490/490_36_hermit_receive1.lua
  (490, 36, $trig$-- Trigger: hermit_receive1
-- Zone: 490, ID: 36
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49036

-- Converted from DG Script #49036: hermit_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.type == "DRINKCONTAINER" then
    wait(2)
    if object.val2 == 5 then
        self:command("cheer")
        self:say("Thank you " .. tostring(actor.name) .. ", you have made an old man very happy.")
        self.room:spawn_object(490, 41)
        local person = actor
        local i = person.group_size
        local a
        if i then
            a = 1
        else
            a = 0
        end
        while i >= a do
            person = person.group_member[a]
            if person.room == self.room then
                if not person:get_quest_stage("griffin_quest") then
                    person:start_quest("griffin_quest")
                end
                person:set_quest_var("griffin_quest", "ladder", 1)
            elseif person and person.is_player then
                i = i + 1
            end
            a = a + 1
        end
        self:command("give ladder " .. tostring(actor.name))
        self:say("That completes my part of the bargain.")
        wait(2)
        self:command("drink bottle")
        self:command("smile")
    else
        self:say("I'm not drinking this!")
        self:command("pour " .. tostring(object.shortdesc) .. " out")
        self:command("drop " .. tostring(object.shortdesc))
    end
else
    _return_value = true
    self:say("What's this for?")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return _return_value$trig$),
  -- data/triggers/625/625_33_rhell_merchant_receive_4-3.lua
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
    if actor:get_quest_var("ursa_quest:choice") == 3 then
        -- for path 3, the merchant asks for an anvil
        -- note - the anvil is extremely heavy but must be picked up and given to the merchant to complete the quest; it cannot just be dragged to him.
        if object.type == "DRINKCONTAINER" then
            if object.val2 == 10 then
                wait(2)
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
                wait(2)
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
return _return_value$trig$),
  -- data/triggers/625/625_35_rhell_merchant_receive_5-2.lua
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
    if actor:get_quest_var("ursa_quest:choice") == 2 then
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
return _return_value$trig$)
) AS v(zone_id, id, commands)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
