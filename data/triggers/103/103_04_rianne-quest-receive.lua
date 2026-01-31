-- Trigger: rianne-quest-receive
-- Zone: 103, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 20 if statements
--   Large script: 9621 chars
--
-- Original DG Script: #10304

-- Converted from DG Script #10304: rianne-quest-receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- 
-- Added by Daedela 3-9-2021 for Group Heal quest
-- 
if actor:get_quest_stage("group_heal") == 5 then
    if actor.quest_variable["group_heal:self.vnum"] then
        if object.id == 18514 then
            self:say("I've told you everything I can.  Good luck!")
            return _return_value
        end
    else
        if object.id == 18514 then
            actor.name:set_quest_var("group_heal", "%self.vnum%", 1)
            _return_value = false
            self:say("Well you've definitely come to the right place!")
            wait(4)
            self:emote("reads over the ritual recipe.")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'Oh my, what a challenge.  No wonder someone would need help with this.'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'The names for many of these ingredients have changed since...  How old is this recipe anyway??'")
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
            self.room:send(tostring(self.name) .. " says, '... that's been extinct for over a century, so perhaps this will do...?'")
            wait(4)
            self:emote("finishes her list.")
            self.room:spawn_object(185, 20)
            self:command("give notes " .. tostring(actor.name))
            wait(2)
            self:say("That should help you.  I can't wait to hear how it goes!")
            self:command("wave " .. tostring(actor))
            return _return_value
        end
    end
end
-- 
-- Original resumes here
-- 
-- Preset item and recipe vars
local item4 = 0
local item5 = 0
local item6 = 0
local item7 = 0
local stage = actor:get_quest_stage("resort_cooking")
local recipe1 = "Peach Cobbler"
local recipe2 = "Seafood Salad"
local recipe3 = "Fish Stew"
local recipe4 = "Honey-Glazed Ham"
local recipe5 = "Saffroned Jasmine Rice"
-- switch on stage
if stage == 1 then
    local recipe = recipe1
    local next = recipe2
    local item1 = 61501
    local item2 = 23754
    local item3 = 3114
    local item4 = 35001
elseif stage == 2 then
    local recipe = recipe2
    local next = recipe3
    local item1 = 49024
    local item2 = 23750
    local item3 = 23722
    local item4 = 8003
    local item5 = 12515
    local item6 = 1606
elseif stage == 3 then
    local recipe = recipe3
    local next = recipe4
    local item1 = 55213
    local item2 = 30002
    local item3 = 10030
    local item4 = 12552
    local item5 = 23757
    local item6 = 18509
    local item7 = 10311
elseif stage == 4 then
    local recipe = recipe4
    local next = recipe5
    local item1 = 41011
    local item2 = 8350
    local item3 = 2001
    local item4 = 50207
    local item5 = 6106
elseif stage == 5 then
    local recipe = recipe5
    local item1 = 58019
    local item2 = 37013
    local item3 = 23760
else
    _return_value = false
    self:say("I don't have time for that right now.")
    self:emote("refuses your item.")
    return _return_value
end
-- What item is being turned in?
-- switch on object.id
if object.id == "%item1%" then
    local item = 1
elseif object.id == "%item2%" then
    local item = 2
elseif object.id == "%item3%" then
    local item = 3
elseif object.id == "%item4%" then
    local item = 4
elseif object.id == "%item5%" then
    local item = 5
elseif object.id == "%item6%" then
    local item = 6
elseif object.id == "%item7%" then
    local item = 7
else
    _return_value = false
    self.room:send(tostring(self.name) .. " says, 'The recipe doesn't call for this!  Perhaps you should consult the recipe on the wall to refresh your memory.'")
    return _return_value
end
if actor.quest_variable["resort_cooking:itemitem"] then
    _return_value = false
    self.room:send(tostring(self.name) .. " says, 'You already brought in " .. tostring(object.shortdesc) .. ", so we don't need more.'")
    self:emote("hands your item back to you.")
    return _return_value
end
wait(1)
world.destroy(object.name)
wait(4)
self.room:send(tostring(self.name) .. " says, 'Just what we need for <b:white>" .. tostring(recipe) .. "</>!'")
actor.name:set_quest_var("resort_cooking", "item%item%", 1)
-- See if we've turned in everything for this recipe
local item = 1
while item <= 7 do
    item[item] = 0
    local item = item + 1
end
if actor:get_quest_var("resort_cooking:item1") then
    local item1 = 1
end
if actor:get_quest_var("resort_cooking:item2") then
    local item2 = 1
end
if actor:get_quest_var("resort_cooking:item3") then
    local item3 = 1
end
if stage == 5 or actor:get_quest_var("resort_cooking:item4") then
    local item4 = 1
end
if stage == 1 or stage == 5 or actor:get_quest_var("resort_cooking:item5") then
    local item5 = 1
end
if (stage ~= 2 and stage ~= 3) or actor.quest_variable["resort_cooking:item6"] then
    local item6 = 1
end
if stage ~= 3 or actor:get_quest_var("resort_cooking:item7") then
    local item7 = 1
end
-- If all the items have been turned in, start mixing
if item1 and item2 and item3 and item4 and item5 and item6 and item7 then
    actor.name:advance_quest("resort_cooking")
    local item = 1
    -- Reset item variables
    while item <= 7 do
        actor.name:set_quest_var("resort_cooking", "item%item%", 0)
        local item = item + 1
    end
    self:say("I think I can start preparing it now.")
    wait(1)
    self:emote("gets the other ingredients from the icebox.")
    self:emote("begins mixing them together.")
    wait(2)
    if stage == 5 then
        self.room:send(tostring(self.name) .. " says, 'You've been such a great help, " .. tostring(actor.name) .. "!  Now I'm almost prepared for this huge dinner party, thanks!'")
        wait(3)
        self:say("I'd like you to have this.")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'It was enchanted by a good friend of mine, so I hope it will help you as much as you've helped me.'")
        self.room:spawn_object(103, 15)
        local gem = 0
        while gem < 3 do
            -- drop was random(1, 11) + 55736 = 55737 to 55747, zone 557, local 37-47
            local drop_local = random(1, 11) + 36
            self.room:spawn_object(557, drop_local)
            local gem = gem + 1
        end
        self:command("give all.gem " .. tostring(actor))
        self:command("give apron " .. tostring(actor))
        --
        -- Set X to the level of the award - code does not run without it
        -- 
        if actor.level < 65 then
            local expcap = actor.level
        else
            local expcap = 65
        end
        local expmod = 0
        if expcap < 9 then
            local expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            local expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            local expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            local expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            local expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            local expmod = 8640 + ((expcap - 48) * 300)
        else
            local expmod = 20940 + ((expcap - 89) * 600)
        end
        -- 
        -- Adjust exp award by class so all classes receive the same proportionate amount
        -- 
        -- switch on actor.class
        if actor.class == "Warrior" or actor.class == "Berserker" then
            -- 
            -- 110% of standard
            -- 
            local expmod = (expmod + (expmod / 10))
        elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
            -- 
            -- 115% of standard
            -- 
            local expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
            -- 
            -- 120% of standard
            -- 
            local expmod = (expmod + (expmod / 5))
        elseif actor.class == "Necromancer" or actor.class == "Monk" then
            -- 
            -- 130% of standard
            -- 
            local expmod = (expmod + (expmod * 2) / 5)
        else
            local expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            -- 
            -- Xexp must be replaced by mexp, oexp, or wexp for this code to work
            -- Pick depending on what is running the trigger
            -- 
            actor:award_exp(setexp)
            local loop = loop + 1
        end
        actor.name:complete_quest("resort_cooking")
    else
        self.room:send(tostring(self.name) .. " says, 'I'll keep preparing this while you collect items for the next recipe.'")
        self:command("ponder")
        wait(1)
        self:say("The next dish is " .. tostring(next) .. ".")
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
return _return_value