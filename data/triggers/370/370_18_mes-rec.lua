-- Trigger: mes-rec
-- Zone: 370, ID: 18
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN (reviewed 2026-01-22)
--   Complex nesting: 11 if statements
--   Large script: 5049 chars
--
-- Original DG Script: #37018

-- Converted from DG Script #37018: mes-rec
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- first lets check the PC is the right race!
if string.find(actor.race, "troll") then
    -- now lets check to make sure the item is correct and we didn't already have it, if both are good then lets mark it gotten.
    local gooditem = 0
    local gotitem = 0
    if object.id == 37080 then
        gooditem = 1
        if actor:get_quest_var("troll_quest:got_item:37080") ~= 1 then
            gotitem = 1
            actor:set_quest_var("troll_quest", "got_item:37080", 1)
        end
    elseif object.id == 37081 then
        gooditem = 1
        if actor:get_quest_var("troll_quest:got_item:37081") ~= 1 then
            gotitem = 1
            actor:set_quest_var("troll_quest", "got_item:37081", 1)
        end
    elseif object.id == 37082 then
        gooditem = 1
        if actor:get_quest_var("troll_quest:got_item:37082") ~= 1 then
            gotitem = 1
            actor:set_quest_var("troll_quest", "got_item:37082", 1)
        end
    end
    -- alright, do we have everything now?
    if actor:get_quest_var("troll_quest:got_item:37080") == 1 and actor:get_quest_var("troll_quest:got_item:37081") == 1 and actor:get_quest_var("troll_quest:got_item:37082") == 1 and not actor:get_has_completed("troll_quest") then
        -- if everything is handed in we're done!
        self.room:send(tostring(self.name) .. " smiles broadly as he looks at the gathered ingredients.")
        self:say("Yes, these will do quite nicely indeed.  Excellent work.")
        wait(2)
        self.room:send(tostring(self.name) .. " opens the seal on the vial of dye and a sweet scent fills the  room.")
        self.room:send("Taking the vial on one hand, he slowly pours it over the mangrove branch, creating a slight hissing noise and a black, oily-smelling smoke.")
        wait(1)
        self.room:send(tostring(self.name) .. " places the hunk of malachite amidst the smoking concoction and")
        -- Fragment (possible truncation): waves his hands over it, muttering a strange mantra
        self.room:send("A red light erupts from the center of the branch, nearly blinding you!")
        wait(2)
        self.room:send("When the smoke clears and the light is gone, " .. tostring(self.name) .. " smiles proudly.")
        actor:complete_quest("troll_quest")
        self:say("Here you go, little one.  May your ambitions guide you and lead you to prosperity and rulership.")
        self.room:spawn_object(370, 83)
        self:command("give troll-mask " .. tostring(actor.name))
        self:command("bow " .. tostring(actor))
        wait(1)
        self:say("I am certain we shall meet again.")
        -- okay maybe we've already done this quest
    elseif actor:get_has_completed("troll_quest") then
        wait(3)
        self:say("You have already helped me once, please let others help me now.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
        -- what if we don't have everything but did have a good item?
    elseif gotitem == 1 then
        wait(3)
        self:say("Why thank you.  Run along now.")
        world.destroy(object.name)
        -- so what if it's a good item but we already have it?
    elseif gooditem == 1 then
        wait(3)
        self:say("I'm sorry but you already gave me this item.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
        -- uh oh, bad item, didn't need this one
    else
        wait(3)
        self:say("What is this? I can not use this.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    end
    -- ending from the race check.
else
    if object.id == 12526 then
        wait(3)
        self:destroy_item("gem")
        self:command("blink")
        self:say("How did you know I needed this?!")
        wait(2)
        self.room:send(tostring(self.name) .. " quickly pockets the ruby.")
        self:say("Here, my thanks.")
        local lap = 1
        while lap < 11 do
            actor:award_exp(10000)
            lap = lap + 1
        end
        local random_gem = random(1, 11)
        local which_gem = random_gem + 55736
        self.room:spawn_object(vnum_to_zone(which_gem), vnum_to_local(which_gem))
        local random_gem = random(1, 11)
        local which_gem = random_gem + 55736
        self.room:spawn_object(vnum_to_zone(which_gem), vnum_to_local(which_gem))
        local random_gem = random(1, 11)
        local which_gem = random_gem + 55736
        self.room:spawn_object(vnum_to_zone(which_gem), vnum_to_local(which_gem))
        self:command("give all.gem " .. tostring(actor.name))
        self:say("Here is a small token of my appreciation.")
        self:say("Now move along.")
    else
        wait(1)
        self:say("What is this? I can not use this.")
        _return_value = false
    end
end
return _return_value