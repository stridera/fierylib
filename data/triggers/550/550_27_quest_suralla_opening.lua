-- Trigger: quest_suralla_opening
-- Zone: 550, ID: 27
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #55027

-- Converted from DG Script #55027: quest_suralla_opening
-- Original: WORLD trigger, flags: COMMAND, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if string.find(arg, "ice") or string.find(arg, "sculpture") then
    actor:send("The light of the ice sculpture swirls around you and you find yourself moving.")
    self.room:send_except(actor, tostring(actor.name) .. " looks at the ice sculpture and is engulfed by light.")
    get_room(550, 15):exit("south"):set_state({hidden = false})
    self.room:send_except(actor, "The ice sculpture splits in two and " .. tostring(actor.name) .. " is sucked through by a strong gust!")
    actor:send("The ice sculpture splits in two and you are sucked through by a strong gust!")
    get_room(550, 0):at(function()
        self.room:send("There is a sudden split in the wall of ice!")
    end)
    actor:move("south")
    wait(1)
    get_room(550, 15):exit("south"):set_state({hidden = true})
    self.room:send("The sculpture seals behind " .. tostring(actor.object) .. ".")
else
    _return_value = false
end
return _return_value