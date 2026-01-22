-- Trigger: find_blood
-- Zone: 590, ID: 14
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59014

-- Converted from DG Script #59014: find_blood
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local now = time.stamp
if actor:get_quest_var("sacred_haven:blood_time") == 0 then
    local last = now - 1
else
    local last = actor:get_quest_var("sacred_haven:blood_time") + 20
end
if actor:get_quest_stage("sacred_haven") == 0 then
    local now = 0
end
if now > last then
    actor:send("You find a vial of dark red dragons blood setting on top of the table.")
    self.room:send_except(actor, tostring(actor.name) .. " finds a vial of dark red dragons blood setting on top of the table.")
    self.room:spawn_object(590, 28)
    actor.name:set_quest_var("sacred_haven", "blood_time", now)
    if actor:get_quest_var("sacred_haven:find_blood") == 1 then
        actor.name:set_quest_var("sacred_haven", "find_blood", 2)
    end
else
    actor:send("You don't see anything you didn't see before.")
end