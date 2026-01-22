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
if actor.id == -1 and actor.level < 31 then
    wait(2)
    self.room:send_except(actor, tostring(actor.name) .. " triggered a hidden tripwire!")
    actor:send("You triggered a hidden tripwire!")
    wait(8)
    local holding = get_room("61599")
    if holding:get_people("61511") then
        get_room(615, 99):at(function()
            self.room:find_actor("stonefang"):move("d")
        end)
    end
    if actor.room == self.id then
        self.room:find_actor("stonefang"):command("kill %actor%")
    end
end