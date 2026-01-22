-- Trigger: mist_attack
-- Zone: 118, ID: 38
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
local _return_value = true  -- Default: allow action
if (arg == "carving") or (arg == "carvings") then
    _return_value = true
    local now = time.stamp
    if (mist_loaded ~= 1) and (last_load < now - 2) then
        local mist_loaded = 1
        globals.mist_loaded = globals.mist_loaded or true
        local last_load = now
        globals.last_load = globals.last_load or true
        self.room:send_except(actor, "As " .. tostring(actor.name) .. " looks at the carvings, an eerie stillness seems to set in...")
        actor:send("As you look at the carvings, an eerie stillness seems to set in...")
        wait(2)
        self.room:spawn_mobile(118, 4)
        self.room:send("The mist seem to come alive, filled with hostility!")
        self.room:send_except(actor, "The mist roars and charges at " .. tostring(actor.name) .. ".")
        actor:send("The mist roars and charges at YOU!")
        wait(2)
        self.room:find_actor("mist-demon"):command("kill %actor.name%")
    else
        actor:send("The mists around the carvings seem ominous and hostile.")
    end
else
    _return_value = false
end
return _return_value