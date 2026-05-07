-- Trigger: mes-rec
-- Zone: 370, ID: 18
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #37018
--
-- Mesmeriz receives quest items from a troll player. The three quest
-- ingredients are mangrove-branch (370,80), red-dye (370,81), and
-- malachite (370,82); turning in all three completes troll_quest and
-- yields the troll-mask (370,83). Non-trolls who hand him a fire
-- ruby (125,26) get an alternate XP + random-gem reward.

-- Quest ingredient table: object zone/id -> quest_var key.
local TROLL_INGREDIENTS = {
    [80] = "got_item:37080",
    [81] = "got_item:37081",
    [82] = "got_item:37082",
}

local function is_troll_ingredient(obj)
    return obj.zone_id == 370 and TROLL_INGREDIENTS[obj.id] ~= nil
end

local function ingredient_key(obj)
    return TROLL_INGREDIENTS[obj.id]
end

if string.find(actor.race, "troll") then
    local gooditem = false
    local gotitem = false
    if is_troll_ingredient(object) then
        gooditem = true
        local key = ingredient_key(object)
        if actor:get_quest_var("troll_quest:" .. key) ~= 1 then
            gotitem = true
            actor:set_quest_var("troll_quest", key, 1)
        end
    end

    -- Have we collected everything?
    local have_all =
        actor:get_quest_var("troll_quest:got_item:37080") == 1
        and actor:get_quest_var("troll_quest:got_item:37081") == 1
        and actor:get_quest_var("troll_quest:got_item:37082") == 1

    if have_all and not actor:get_has_completed("troll_quest") then
        self.room:send(tostring(self.name) .. " smiles broadly as he looks at the gathered ingredients.")
        self:say("Yes, these will do quite nicely indeed.  Excellent work.")
        wait(2)
        self.room:send(tostring(self.name) .. " opens the seal on the vial of dye and a sweet scent fills the  room.")
        self.room:send("Taking the vial on one hand, he slowly pours it over the mangrove branch, creating a slight hissing noise and a black, oily-smelling smoke.")
        wait(1)
        self.room:send(tostring(self.name) .. " places the hunk of malachite amidst the smoking concoction and waves his hands over it, muttering a strange mantra.")
        self.room:send("A red light erupts from the center of the branch, nearly blinding you!")
        wait(2)
        self.room:send("When the smoke clears and the light is gone, " .. tostring(self.name) .. " smiles proudly.")
        actor:complete_quest("troll_quest")
        self:say("Here you go, little one.  May your ambitions guide you and lead you to prosperity and rulership.")
        self.room:spawn_object(370, 83)
        self:command("give troll-mask " .. tostring(actor.name))
        self:command("bow " .. tostring(actor.name))
        wait(1)
        self:say("I am certain we shall meet again.")
    elseif actor:get_has_completed("troll_quest") then
        wait(3)
        self:say("You have already helped me once, please let others help me now.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    elseif gotitem then
        wait(3)
        self:say("Why thank you.  Run along now.")
        world.destroy(object)
    elseif gooditem then
        wait(3)
        self:say("I'm sorry but you already gave me this item.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    else
        wait(3)
        self:say("What is this? I can not use this.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    end
else
    -- Non-troll path: the fire ruby (125,26) gives an XP + gem reward.
    if object.zone_id == 125 and object.id == 26 then
        wait(3)
        self:destroy_item("gem")
        self:command("blink")
        self:say("How did you know I needed this?!")
        wait(2)
        self.room:send(tostring(self.name) .. " quickly pockets the ruby.")
        self:say("Here, my thanks.")
        for _ = 1, 10 do
            actor:award_exp(10000)
        end
        -- Three random gems from the (557, 37..47) range.
        for _ = 1, 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
        end
        self:command("give all.gem " .. tostring(actor.name))
        self:say("Here is a small token of my appreciation.")
        self:say("Now move along.")
    else
        wait(1)
        self:say("What is this? I can not use this.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    end
end
return true
