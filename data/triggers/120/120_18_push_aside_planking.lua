-- Trigger: Push aside planking
-- Zone: 120, ID: 18
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12018

-- Converted from DG Script #12018: Push aside planking
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: push
if cmd ~= "push" then
    return true  -- Not our command
end
if string.find(arg or "", "planking") then
    globals.planking_open = 1
    get_room(120, 93):exit("south"):set_state({hidden = false})
    get_room(120, 93):exit("south"):set_state({description = "The broken planking hangs askew."})
    get_room(120, 93):exit("south"):set_state({name = "planking"})
    self.room:send_except(actor, actor.name .. " pushes aside some planking on the south wall.")
    actor:send("You push aside some planking, revealing an opening to the south.")
    get_room(120, 39):at(function()
        self.room:send("Some planks in the wall are swung aside.")
    end)
    wait(5)
    self.room:send("The planking swings back down.")
    get_room(120, 93):exit("south"):set_state({hidden = true})
    globals.planking_open = 0
end
return true