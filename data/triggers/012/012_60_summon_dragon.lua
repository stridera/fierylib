-- Trigger: summon_dragon
-- Zone: 12, ID: 60
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1260

-- Converted from DG Script #1260: summon_dragon
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: summon
if not (cmd == "summon") then
    return true  -- Not our command
end
if has_one ~= "yes" then
    if actor.class == "Paladin" then
        self.room:spawn_mobile(12, 60)
        self.room:send_except(actor, "A brilliant golden dragon flies in, seemingly from nowhere, and nuzzles " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A brilliant golden dragon answers your summons.")
        self.room:find_actor("golden-dragon"):follow(actor.name)
        self.room:find_actor("golden-dragon"):spawn_object(12, 62)
        self.room:find_actor("golden-dragon"):command("wear dragonsaddle")
    elseif string.find(actor.class, "Anti") then
        self.room:spawn_mobile(12, 63)
        self.room:send_except(actor, "A dusky black dragon flies in, seemingly from nowhere, and sits by " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A dusky black dragon answers your summons.")
        self.room:find_actor("black-dragon"):follow(actor.name)
        self.room:find_actor("black-dragon"):spawn_object(12, 62)
        self.room:find_actor("black-dragon"):command("wear dragonsaddle")
    else
        actor:send("You begin calling for a mount...but nothing happens.")
        self.room:send_except(actor, tostring(actor.name) .. " whistles loudly.")
    end
    local has_one = "yes"
    globals.has_one = globals.has_one or true
else
end