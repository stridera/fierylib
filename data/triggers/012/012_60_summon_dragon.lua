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
-- TODO: per-summoner one-mount-only gate (DG used a global var here);
-- the converter emitted dead `globals.has_one = globals.has_one or true`
-- which never blocked re-summons. Leaving open until the runtime exposes
-- a per-actor quest/flag suitable for tracking summoned mounts.
if actor.class == "Paladin" then
    self.room:spawn_mobile(12, 60)
    self.room:send_except(actor, "A brilliant golden dragon flies in, seemingly from nowhere, and nuzzles " .. tostring(actor.name) .. "'s side.")
    actor:send("You begin calling for a mount..")
    actor:send("A brilliant golden dragon answers your summons.")
    local dragon = self.room:find_actor("golden-dragon")
    if dragon then
        dragon:follow(actor)
        dragon:spawn_object(12, 62)
        dragon:command("wear dragonsaddle")
    end
elseif string.find(actor.class, "Anti") then
    self.room:spawn_mobile(12, 63)
    self.room:send_except(actor, "A dusky black dragon flies in, seemingly from nowhere, and sits by " .. tostring(actor.name) .. "'s side.")
    actor:send("You begin calling for a mount..")
    actor:send("A dusky black dragon answers your summons.")
    local dragon = self.room:find_actor("black-dragon")
    if dragon then
        dragon:follow(actor)
        dragon:spawn_object(12, 62)
        dragon:command("wear dragonsaddle")
    end
else
    actor:send("You begin calling for a mount...but nothing happens.")
    self.room:send_except(actor, tostring(actor.name) .. " whistles loudly.")
end