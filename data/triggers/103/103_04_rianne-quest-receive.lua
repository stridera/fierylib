-- Trigger: rianne-quest-receive
-- Zone: 103, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #10304
-- Item-handler for the resort_cooking quest. Each stage 1..5 has a
-- distinct ingredient list (item1..item7); the matching item is
-- consumed, recorded as a quest var, and once all per-stage
-- ingredients have been turned in, the quest advances. Stage 5
-- final completion awards a gem, three random gems, and a class-
-- adjusted experience bonus.
--
-- TODO(parity): the original DG pivoted on `%object.vnum% == %itemN%`,
-- comparing the legacy 5-digit vnum to per-stage ingredient vnums.
-- The runtime equivalent needs (zone_id, local_id) tuples. Below we
-- carry per-stage ingredient tables of (zone, id) pairs and match on
-- (object.zone_id, object.local_id). The exp curve and class bonuses
-- are preserved verbatim. The Daedela "group_heal" sub-branch at the
-- top is also preserved; it unconditionally hands out an item-185-20
-- (notes) when given a book(18514) by an actor in stage 5 of
-- group_heal who has not yet received notes.

local function obj_key(o)
    return tostring(o.zone_id) .. "_" .. tostring(o.local_id)
end

-- ---------------------------------------------------------------
-- Daedela group_heal sub-branch (added 3-9-2021)
-- ---------------------------------------------------------------
if actor:get_quest_stage("group_heal") == 5 then
    local self_key = "group_heal:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)
    local already = actor:get_quest_var(self_key)
    -- 18514 is a book — naive vnum mapping is (185, 14)
    if object.zone_id == 185 and object.local_id == 14 then
        if already and already ~= "" and already ~= "0" then
            self:say("I've told you everything I can.  Good luck!")
            return true
        end
        actor:set_quest_var("group_heal", tostring(self.zone_id) .. "_" .. tostring(self.local_id), 1)
        self:say("Well you've definitely come to the right place!")
        wait(4)
        self:emote("reads over the ritual recipe.")
        wait(4)
        self.room:send(self.name .. " says, 'Oh my, what a challenge.  No wonder someone would need help with this.'")
        wait(3)
        self.room:send(self.name .. " says, 'The names for many of these ingredients have changed since...  How old is this recipe anyway??'")
        wait(1)
        self:command("beam")
        self:say("I love it.")
        wait(3)
        self:emote("begins writing down a list of notes.")
        wait(1)
        self:say("... and this is called this...")
        wait(1)
        self:say("... this can be substituted with this...")
        wait(2)
        self.room:send(self.name .. " says, '... that's been extinct for over a century, so perhaps this will do...?'")
        wait(4)
        self:emote("finishes her list.")
        self.room:spawn_object(185, 20)
        self:command("give notes " .. actor.name)
        wait(2)
        self:say("That should help you.  I can't wait to hear how it goes!")
        self:command("wave " .. actor.name)
        return true
    end
end

-- ---------------------------------------------------------------
-- resort_cooking
-- ---------------------------------------------------------------
local stage = actor:get_quest_stage("resort_cooking")
local recipe, next_recipe
local ingredients  -- list of {zone, id} for the seven slots
local slot_count

-- Per-stage ingredient tables. Each row is {zone, id}; rows 1..N
-- must match the original item1..itemN vnums. nil-tail rows are
-- absent slots for that stage.
if stage == 1 then
    recipe, next_recipe = "Peach Cobbler", "Seafood Salad"
    ingredients = {{615, 1}, {237, 54}, {30, 114}, {350, 1}}
    slot_count = 4
elseif stage == 2 then
    recipe, next_recipe = "Seafood Salad", "Fish Stew"
    ingredients = {{490, 24}, {237, 50}, {237, 22}, {80, 3}, {125, 15}, {16, 6}}
    slot_count = 6
elseif stage == 3 then
    recipe, next_recipe = "Fish Stew", "Honey-Glazed Ham"
    ingredients = {{552, 13}, {300, 2}, {100, 30}, {125, 52}, {237, 57}, {185, 9}, {103, 11}}
    slot_count = 7
elseif stage == 4 then
    recipe, next_recipe = "Honey-Glazed Ham", "Saffroned Jasmine Rice"
    ingredients = {{410, 11}, {83, 50}, {20, 1}, {502, 7}, {61, 6}}
    slot_count = 5
elseif stage == 5 then
    recipe = "Saffroned Jasmine Rice"
    ingredients = {{580, 19}, {370, 13}, {237, 60}}
    slot_count = 3
else
    self:say("I don't have time for that right now.")
    self:emote("refuses your item.")
    return false
end

-- Which slot does the offered object match?
local matched_slot
for i = 1, slot_count do
    local row = ingredients[i]
    if row and object.zone_id == row[1] and object.local_id == row[2] then
        matched_slot = i
        break
    end
end
if not matched_slot then
    self.room:send(self.name .. " says, 'The recipe doesn't call for this!  Perhaps you should consult the recipe on the wall to refresh your memory.'")
    return false
end

-- Already turned this one in?
local slot_key = "item" .. tostring(matched_slot)
local already = actor:get_quest_var("resort_cooking:" .. slot_key)
if already and already ~= "" and already ~= "0" then
    self.room:send(self.name .. " says, 'You already brought in " .. tostring(object.shortdesc) .. ", so we don't need more.'")
    self:emote("hands your item back to you.")
    return false
end

wait(1)
world.destroy(object)
wait(4)
self.room:send(self.name .. " says, 'Just what we need for <b:white>" .. recipe .. "</>!'")
actor:set_quest_var("resort_cooking", slot_key, 1)

-- All per-stage slots collected?
local complete = true
for i = 1, slot_count do
    local v = actor:get_quest_var("resort_cooking:item" .. tostring(i))
    if not v or v == "" or v == "0" then
        complete = false
        break
    end
end

if complete then
    actor:advance_quest("resort_cooking")
    -- Reset the per-stage slot vars
    for i = 1, slot_count do
        actor:set_quest_var("resort_cooking", "item" .. tostring(i), 0)
    end
    self:say("I think I can start preparing it now.")
    wait(1)
    self:emote("gets the other ingredients from the icebox.")
    self:emote("begins mixing them together.")
    wait(2)

    if stage == 5 then
        -- Final reward
        self.room:send(self.name .. " says, 'You've been such a great help, " .. actor.name .. "!  Now I'm almost prepared for this huge dinner party, thanks!'")
        wait(3)
        self:say("I'd like you to have this.")
        wait(5)
        self.room:send(self.name .. " says, 'It was enchanted by a good friend of mine, so I hope it will help you as much as you've helped me.'")
        self.room:spawn_object(103, 15)
        for _ = 1, 3 do
            -- TODO(parity): original spawned random.gem from a 55736+1..11
            -- contiguous range; runtime has no slot range helper, so we
            -- approximate with the same numeric range mapped to (557, 36..46).
            self.room:spawn_object(557, 36 + random(1, 11))
        end
        self:command("give all.gem " .. actor.name)

        -- Class-adjusted experience curve, preserved verbatim
        local expcap = actor.level
        if expcap > 65 then expcap = 65 end
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

        local cls = actor.class
        if cls == "Warrior" or cls == "Berserker" then
            expmod = expmod + (expmod / 10)
        elseif cls == "Paladin" or cls == "Anti-Paladin" or cls == "Ranger" then
            expmod = expmod + ((expmod * 2) / 15)
        elseif cls == "Sorcerer" or cls == "Pyromancer" or cls == "Cryomancer"
            or cls == "Illusionist" or cls == "Bard" then
            expmod = expmod + (expmod / 5)
        elseif cls == "Necromancer" or cls == "Monk" then
            expmod = expmod + (expmod * 2) / 5
        end

        actor:send("<b:yellow>You gain experience!</>")
        local setexp = expmod * 10
        for _ = 1, 10 do
            actor:award_exp(setexp)
        end
        actor:complete_quest("resort_cooking")
    else
        self.room:send(self.name .. " says, 'I'll keep preparing this while you collect items for the next recipe.'")
        self:command("ponder")
        wait(1)
        self:say("The next dish is " .. tostring(next_recipe) .. ".")
        wait(2)
        self:say("Here's the recipe.  Please take a look at it.")
        self:emote("points out a slip of paper hanging on the wall.")
    end
else
    self:emote("puts the item into the icebox.")
    wait(1)
    self:say("Thanks!  Quickly, bring the rest!")
end

self:command("drop all")
return true
