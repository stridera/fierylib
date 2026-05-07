-- Trigger: dragonegg_hatch
-- Zone: 188, ID: 93
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
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
    _return_value = true
    return _return_value
end
local color, obj_id
if actor.class == "Paladin" then
    color = "golden"
    obj_id = 90
elseif string.find(actor.class, "Anti") then
    color = "black"
    obj_id = 91
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
    self.room:spawn_mobile(188, obj_id)
    actor:send("The " .. tostring(color) .. " dragon looks at you.")
    self.room:send_except(actor, "The " .. tostring(color) .. " dragon looks at " .. tostring(actor.name) .. ".")
    wait(3)
    local dragon_name = color .. "-dragon"
    local dragon = self.room:find_actor(dragon_name)
    if dragon then
        dragon:command("bow")
        if actor.gender == "Female" then
            dragon:say("Mistress, thank you for protecting me.")
        else
            dragon:say("Master, thank you for protecting me.")
        end
        dragon:say("Henceforth shall I be at your command.  Merely call and I shall answer!")
    end
    wait(5)
    if dragon then dragon:emote("looks around itself.") end
    self.room:send("In a rush of wind, the dragon beats its wings, launching itself into the air.")
    if dragon then world.destroy(dragon) end
    wait(2)
    actor:send("A strange-looking helmet falls from behind the dragon, landing near you.")
    self.room:send_except(actor, "A strange-looking helmet falls from behind the dragon, landing near " .. tostring(actor.name) .. ".")
    self.room:spawn_object(188, obj_id)
    if actor:get_quest_stage("quest_items") == 0 then
        actor:start_quest("quest_items")
    end
    actor:set_quest_var("quest_items", tostring(obj_id), 1)
    actor:command("get dragonhelm")
    world.destroy(self)
end
return _return_value