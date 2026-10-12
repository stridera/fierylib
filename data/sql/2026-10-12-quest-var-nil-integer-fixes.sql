-- Quest vars now return nil/integer: numeric-safe slot checks
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/018/018_33_blur_winds_preentry.lua
  (18, 33, $trig$-- Converted from DG Script #1833: blur_winds_preentry
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor:get_quest_stage("blur") ~= 4 then
    return true
end

local direction
local mob
if self.zone_id == 100 and self.local_id == 1 then  -- North wind shrine (legacy 10001)
    direction = "north"
    mob = 19
elseif self.zone_id == 24 and self.local_id == 60 then  -- South wind shrine (legacy 2460)
    direction = "south"
    mob = 20
elseif self.zone_id == 482 and self.local_id == 23 then  -- East wind shrine (legacy 48223)
    direction = "east"
    mob = 21
elseif self.zone_id == 203 and self.local_id == 79 then  -- West wind shrine (legacy 20379)
    direction = "west"
    mob = 22
end

local blur_v = direction and actor:get_quest_var("blur:" .. direction)
if mob and (not blur_v or blur_v == 0) and world.count_mobiles(18, mob) == 0 then
    self.room:spawn_mobile(18, mob)
end
return true$trig$, '1d3cc8f66886cfdf8721eafa3e19f34f'),
  -- data/triggers/053/053_46_elemental_chaos_target_death.lua
  (53, 46, $trig$local TARGETS = {
    { zone = 588, id = 8,  stage = 1,  slot = 1, target = "imp" },
    { zone = 43,  id = 99, stage = 2,  slot = 1, target = "Leading_player" },
    { zone = 173, id = 6,  stage = 3,  slot = 1, target = "Chaos" },
    { zone = 178, id = 11, stage = 4,  slot = 1, target = "Fetch" },
    { zone = 462, id = 6,  stage = 5,  slot = 1, target = "shaman_Fang" },
    { zone = 462, id = 7,  stage = 5,  slot = 2, target = "necro_Fang" },
    { zone = 462, id = 8,  stage = 5,  slot = 3, target = "dia_Fang" },
    { zone = 125, id = 23, stage = 6,  slot = 1, target = "fire_lord" },
    { zone = 85,  id = 9,  stage = 7,  slot = 1, target = "acolyte" },
    { zone = 430, id = 17, stage = 8,  slot = 1, target = "Cyprianum" },
    { zone = 534, id = 17, stage = 9,  slot = 1, target = "Chaos_Demon" },
    { zone = 40,  id = 9,  stage = 10, slot = 1, target = "Norhamen" },
}

-- get_quest_var returns nil for an unset variable (and "" is tolerated for old rows).
local function is_set(v)
    return v ~= nil and v ~= ""
end

local entry = nil
for _, t in ipairs(TARGETS) do
    if t.zone == self.zone_id and t.id == self.local_id then
        entry = t
        break
    end
end
-- The killer's group (a lone killer is a group of one).
if entry and actor then
    local members = actor.group_member
    for i = 1, actor.group_size do
        local person = members[i]
        if person and person.is_player and person.room == self.room then
            if person:get_quest_stage("elemental_chaos") == entry.stage
                and person:get_quest_var("elemental_chaos:bounty") == "running" then
                person:set_quest_var("elemental_chaos", "target" .. entry.slot, entry.target)
                person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
                if entry.stage == 5 then
                    if is_set(person:get_quest_var("elemental_chaos:target1"))
                        and is_set(person:get_quest_var("elemental_chaos:target2"))
                        and is_set(person:get_quest_var("elemental_chaos:target3")) then
                        person:set_quest_var("elemental_chaos", "bounty", "dead")
                    end
                else
                    person:set_quest_var("elemental_chaos", "bounty", "dead")
                end
            end
        end
    end
end$trig$, 'bd5da087b5123ac2362d858cddd3081d'),
  -- data/triggers/103/103_04_rianne-quest-receive.lua
  (103, 4, $trig$local function obj_key(o)
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
        if already and already ~= 0 and already ~= "" and already ~= "0" then
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
if already and already ~= 0 and already ~= "" and already ~= "0" then
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
    if not v or v == 0 or v == "" or v == "0" then
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
return true$trig$, '2511ae4d5f4a1dbdbbb6dea1bd9ae2d9'),
  -- data/triggers/103/103_05_rianne-quest-look.lua
  (103, 5, $trig$if cmd ~= "look" then
    return true
end

local stage = actor:get_quest_stage("resort_cooking")
if stage < 1 or stage > 5 then
    return true
end

-- Per-stage recipe + ingredient list (mirrors 103_04). Each row is
-- {zone, id}; nil-tail rows are absent slots for that stage.
local recipe
local ingredients
if stage == 1 then
    recipe = "Peach Cobbler"
    ingredients = {{615, 1}, {237, 54}, {30, 114}, {350, 1}}
elseif stage == 2 then
    recipe = "Seafood Salad"
    ingredients = {{490, 24}, {237, 50}, {237, 22}, {80, 3}, {125, 15}, {16, 6}}
elseif stage == 3 then
    recipe = "Fish Stew"
    ingredients = {{552, 13}, {300, 2}, {100, 30}, {125, 52}, {237, 57}, {185, 9}, {103, 11}}
elseif stage == 4 then
    recipe = "Honey-Glazed Ham"
    ingredients = {{410, 11}, {83, 50}, {20, 1}, {502, 7}, {61, 6}}
else  -- stage == 5
    recipe = "Saffroned Jasmine Rice"
    ingredients = {{580, 19}, {370, 13}, {237, 60}}
end

local function shortdesc(row)
    return objects.template(row[1], row[2]).name
end

local a = string.lower(arg or "")
if string.find(a, "recipe") or string.find(a, "wall")
   or string.find(a, "paper") or string.find(a, "slip") then
    actor:send("The wall is covered in slips of paper, each with a different recipe.  One")
    actor:send("</>especially stands out among the mess.")
    actor:send("</>")
    actor:send("</>==========<b:white>" .. recipe .. "</>==========")
    for _, row in ipairs(ingredients) do
        actor:send("</>  " .. shortdesc(row))
    end
    return false
elseif string.find(a, "icebox") then
    actor:send("Looking inside the icebox, you see:")
    local nothing = true
    for i, row in ipairs(ingredients) do
        local v = actor:get_quest_var("resort_cooking:item" .. tostring(i))
        if v and v ~= 0 and v ~= "" and v ~= "0" then
            actor:send("</>  " .. shortdesc(row))
            nothing = false
        end
    end
    if nothing then
        actor:send("</>  Nothing.")
    end
    return false
end

return true$trig$, '629f05a8658e31d7083f23ccc8a340d9'),
  -- data/triggers/103/103_13_ice_shards_khysan_receive1.lua
  (103, 13, $trig$if actor:get_quest_stage("ice_shards") ~= 1 then
    return true
end

local key = "ice_shards:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)
local prior = actor:get_quest_var(key)
if prior and prior ~= 0 and prior ~= "" and prior ~= "0" then
    self.room:send(self.name .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("Thanks, but you already delivered " .. tostring(object.shortdesc) .. " to me.")
    return false
end

actor:set_quest_var("ice_shards", tostring(object.zone_id) .. "_" .. tostring(object.local_id), 1)
self:destroy_item("book")
wait(2)
self.room:send(self.name .. "'s eyes grow wide.")
self:say("This is incredible!  I never imagined I'd be holding a copy of " .. tostring(object.shortdesc) .. "!")
wait(2)

-- The four target books, looked up by composite (zone, id):
--   16209 → (162, 9)   the Book of Kings
--   18505 → (185, 5)   the Book of Discipline
--   55003 → (550, 3)   the Xapizan Codex
--   58415 → (584, 15)  the Enchiridion
local function got(z, i)
    local v = actor:get_quest_var("ice_shards:" .. tostring(z) .. "_" .. tostring(i))
    return v and v ~= 0 and v ~= "" and v ~= "0"
end

if got(162, 9) and got(185, 5) and got(550, 3) and got(584, 15) then
    actor:advance_quest("ice_shards")
    self:emote("slowly reads through the contents of each book.")
    wait(4)
    self:emote("takes copious notes.")
    wait(1)
    self:say("Hmmmm, I wonder if...")
    wait(1)
    self:say("No, that won't work...")
    wait(4)
    self:emote("sighs with frustration.")
    self:say("I hate to say it, but this isn't going to cut it.  The texts just don't have enough information about the spell.")
    wait(3)
    self:command("ponder")
    self.room:send(self.name .. " says, 'There is a mention of Shiran being near Mt. Frostbite in the Xapizan Codex however.  It also mentions a brother codex called <b:yellow>\"The Codex of War\"</>.")
    wait(2)
    self:say("Supposedly, the Codex of War contains a detailed history of battles in the region.  Maybe if Shiran was destroyed in some kind of conflict, the Codex of War might have more clues.")
    wait(2)
    self:say("Try to find a copy and bring it back so we can take a look at it!")
else
    self:say("Did you manage to find any of the other books?")
end

return true$trig$, '0a82ff685fa409db225474b25fa5b679'),
  -- data/triggers/103/103_18_ice_shards_status_tracker.lua
  (103, 18, $trig$local s = string.lower(speech)
if not (string.find(s, "ice") or string.find(s, "shards") or string.find(s, "progress")) then
    return true
end

wait(2)
local stage = actor:get_quest_stage("ice_shards")

local function got(z, i)
    local v = actor:get_quest_var("ice_shards:" .. tostring(z) .. "_" .. tostring(i))
    return v and v ~= 0 and v ~= "" and v ~= "0"
end

if stage == 1 then
    local books = {
        {162, 9},   -- the Book of Kings
        {185, 5},   -- the Book of Discipline
        {550, 3},   -- the Xapizan Codex
        {584, 15},  -- the Enchiridion
    }
    self:say("You are looking for four books of mystic knowledge.")

    local any_in = false
    for _, b in ipairs(books) do
        if got(b[1], b[2]) then any_in = true; break end
    end
    if any_in then
        self.room:send("You have brought me:")
        for _, b in ipairs(books) do
            if got(b[1], b[2]) then
                self.room:send("- <b:yellow>" .. objects.template(b[1], b[2]).name .. "</>")
            end
        end
    end
    self.room:send("You still need to find:")
    for _, b in ipairs(books) do
        if not got(b[1], b[2]) then
            self.room:send("- <b:yellow>" .. objects.template(b[1], b[2]).name .. "</>")
        end
    end
elseif stage == 2 then
    self:say("I need you to find the Codex of War.")
elseif stage == 3 then
    self.room:send(self.name .. " says, 'You are looking for any records or journals Commander")
    self.room:send("</>Thraja keeps.'")
elseif stage == 4 then
    self.room:send(self.name .. " says, 'Talk to the pawnbroker in Anduin about the Butcher of")
    self.room:send("</>Anduin so you can find his map.'")
elseif stage == 5 then
    self.room:send(self.name .. " says, 'Talk to Slevvirik in Ogakh about the Butcher of Anduin")
    self.room:send("</>so you can find his map.'")
elseif stage == 6 then
    self:say("Bring the map of Ickle from the Butcher of Anduin.")
elseif stage == 7 then
    self.room:send(self.name .. " says, 'You are looking for any kind of written clues about the")
    self.room:send("</>library at Shiran in Ysgarran's Keep in Frost Valley.'")
elseif stage == 8 then
    self.room:send(self.name .. " says, 'You are looking for the Book of Redemption, whatever")
    self.room:send("</>that is.'")
elseif stage == 9 then
    self.room:send(self.name .. " says, 'You are looking for the lost library of Shiran in Frost")
    self.room:send("</>Valley!'")
elseif stage == 10 then
    self:say("Have you found the magic book in the lost library??")
elseif actor:get_has_completed("ice_shards") then
    self.room:send(self.name .. " says, 'You've already done a miraculous thing by bring the")
    self.room:send("</>Aqua Mundi to me!")
else
    self:say("Progress on what?  There's no fee to use the springs.")
    self:command("smile " .. actor.name)
end$trig$, 'c278bd15bfe6afe0892ecf5d24b19590')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
