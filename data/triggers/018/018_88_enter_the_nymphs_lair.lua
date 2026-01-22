-- Trigger: Enter the nymphs lair
-- Zone: 18, ID: 88
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1888

-- Converted from DG Script #1888: Enter the nymphs lair
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if self:get_people("1808") then
    if actor.level < 61 then
        wait(2)
        actor.name:send("The nymph cackles, 'So, Thelmor has sent you fools to kill me...'")
    elseif actor.level < 100 then
        wait(3)
        actor.name:send("The nymph says to you, 'You do not belong here.  Begone!'")
        actor.name:teleport(get_room(18, 13))
        wait(1)
        get_room(18, 13):at(function()
            actor.name:send("Your vision fades, and you find yourself at the end of a gravel path.")
        end)
    end
end