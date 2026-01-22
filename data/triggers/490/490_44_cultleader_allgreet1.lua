-- Trigger: cultleader_allgreet1
-- Zone: 490, ID: 44
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #49044

-- Converted from DG Script #49044: cultleader_allgreet1
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.id == -1 then
    get_room(490, 83):at(function()
        self.room:find_actor("ai"):command("give load-dagon-flag cult")
    end)
end