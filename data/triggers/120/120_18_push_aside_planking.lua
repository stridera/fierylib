-- Trigger: Push aside planking
-- Zone: 120, ID: 18
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12018

-- Converted from DG Script #12018: Push aside planking
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: push
if not (cmd == "push") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "p" or cmd == "pu" then
    _return_value = false
    return _return_value
end
if string.find(arg, "planking") then
    local planking_open = 1
    globals.planking_open = globals.planking_open or true
    doors.set_state(get_room(120, 93), "south", {action = "room"})
    doors.set_description(get_room(120, 93), "south", "The broken planking hangs askew.")
    doors.set_name(get_room(120, 93), "south", "planking")
    self.room:send_except(actor, tostring(actor.name) .. " pushes aside some planking on the south wall.")
    actor:send("You push aside some planking, revealing an opening to the south.")
    get_room(120, 39):at(function()
        self.room:send("Some planks in the wall are swung aside.")
    end)
    wait(5)
    self.room:send("The planking swings back down.")
    doors.set_state(get_room(120, 93), "south", {action = "purge"})
    local planking_open = 0
    globals.planking_open = globals.planking_open or true
else
    _return_value = false
end
return _return_value