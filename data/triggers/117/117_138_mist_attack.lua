-- Trigger: mist_attack
-- Zone: 117, ID: 138
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #11838

-- Converted from DG Script #11838: mist_attack
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end
if (arg == "carving") or (arg == "carvings") then
    local now = timestamp()
    local last_load = globals.last_load or 0
    if (globals.mist_loaded ~= 1) and (last_load < now - 2) then
        globals.mist_loaded = 1
        globals.last_load = now
        self.room:send_except(actor, "As " .. tostring(actor.name) .. " looks at the carvings, an eerie stillness seems to set in...")
        actor:send("As you look at the carvings, an eerie stillness seems to set in...")
        wait(2)
        self.room:spawn_mobile(117, 104)
        self.room:send("The mist seem to come alive, filled with hostility!")
        self.room:send_except(actor, "The mist roars and charges at " .. tostring(actor.name) .. ".")
        actor:send("The mist roars and charges at YOU!")
        wait(2)
        local demon = self.room:find_actor("mist-demon")
        if demon then
            demon:command("kill " .. tostring(actor.name))
        end
    else
        actor:send("The mists around the carvings seem ominous and hostile.")
    end
    return false  -- block the look command
end
return true