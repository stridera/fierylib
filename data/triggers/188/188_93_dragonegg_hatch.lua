-- Trigger: dragonegg_hatch
-- Zone: 188, ID: 93
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #18893

-- Converted from DG Script #18893: dragonegg_hatch
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: hatch
if not (cmd == "hatch") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "h" or cmd == "ha" then
    _return_value = false
    return _return_value
end
if actor.class == "Paladin" then
    local color = "golden"
    local vnum = 18890
elseif string.find(actor.class, "Anti") then
    local color = "black"
    local vnum = 18891
else
    actor:send("You get the feeling that this egg is not meant for you.")
end
if color then
    actor:send("As you rub the egg, a crack begins to form...")
    self.room:send_except(actor, "As " .. tostring(actor.name) .. " rubs " .. tostring(self.shortdesc) .. ", a crack begins to form...")
    wait(3)
    self.room:send("The crack continues to grow, branching into hundreds of smaller cracks!")
    wait(6)
    self.room:send("A talon suddenly breaks through the egg shell!")
    wait(3)
    self.room:send("Slowly, the head of a " .. tostring(color) .. " dragon pushes through the shell.")
    wait(2)
    self.room:send("The dragon egg continues to split into pieces.")
    wait(2)
    self.room:send("A small, " .. tostring(color) .. " dragon emerges from the broken egg shell.")
    self.room:spawn_mobile(vnum_to_zone(vnum), vnum_to_local(vnum))
    actor:send("The " .. tostring(color) .. " dragon looks at you.")
    self.room:send_except(actor, "The " .. tostring(color) .. " dragon looks at " .. tostring(actor.name) .. ".")
    wait(3)
    self.room:find_actor("%color%-dragon"):command("bow")
    if actor.gender == "Female" then
        self.room:find_actor("%color%-dragon"):say("Mistress, thank you for protecting me.")
    else
        self.room:find_actor("%color%-dragon"):say("Master, thank you for protecting me.")
    end
    self.room:find_actor("%color%-dragon"):say("Henceforth shall I be at your command.  Merely call and I shall answer!")
    wait(5)
    self.room:find_actor("%color%-dragon"):emote("looks around itself.")
    self.room:send("In a rush of wind, the dragon beats its wings, launching itself into the air.")
    world.destroy(self.room:find_object("%color%-dragon"))
    wait(2)
    actor:send("A strange-looking helmet falls from behind the dragon, landing near you.")
    self.room:send_except(actor, "A strange-looking helmet falls from behind the dragon, landing near " .. tostring(actor.name) .. ".")
    self.room:spawn_object(vnum_to_zone(vnum), vnum_to_local(vnum))
    if actor:get_quest_stage("quest_items") == 0 then
        actor.name:start_quest("quest_items")
    end
    actor.name:set_quest_var("quest_items", "%vnum%", 1)
    actor:command("get dragonhelm")
    world.destroy(self)
end
return _return_value