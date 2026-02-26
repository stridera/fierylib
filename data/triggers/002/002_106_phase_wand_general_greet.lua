-- Trigger: phase wand general greet
-- Zone: 2, ID: 106
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <phase wand general greet>:7: function arguments expected near ']'
--
-- Original DG Script: #306

-- Converted from DG Script #306: phase wand general greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local minlevel = (wandstep - 1) * 10
if actor.quest_stage[type_wand] == "wandstep" then
    if actor.level >= minlevel then
        if actor.quest_variable[type_wand:greet] == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            self:say("Do you have what I need?")
        end
    end
end