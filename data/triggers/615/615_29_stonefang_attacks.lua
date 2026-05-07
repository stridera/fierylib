-- Trigger: Stonefang attacks
-- Zone: 615, ID: 29
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #61529

-- Converted from DG Script #61529: Stonefang attacks
-- Original: WORLD trigger, flags: PREENTRY, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
if actor.is_player and actor.level < 31 then
    wait(2)
    self.room:send_except(actor, tostring(actor.name) .. " triggered a hidden tripwire!")
    actor:send("You triggered a hidden tripwire!")
    wait(8)
    local holding = get_room(615, 99)
    if holding and holding:find_actor("stonefang") then
        holding:at(function()
            self.room:find_actor("stonefang"):command("down")
        end)
    end
    if actor.room == self.room then
        local stonefang = self.room:find_actor("stonefang")
        if stonefang then
            stonefang:command("kill " .. tostring(actor.name))
        end
    end
end