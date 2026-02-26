-- Trigger: LP2_bard_subclass_command_dance
-- Zone: 43, ID: 58
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #4358

-- Converted from DG Script #4358: LP2_bard_subclass_command_dance
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: dance
if not (cmd == "dance") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "d" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("bard_subclass") == 2 then
    if not actor:has_equipped("4315") then
        if actor:get_worn("feet") then
            local shoes = actor:get_worn("feet")
        end
        actor:send("You start to dance when " .. tostring(self.name) .. " abruptly stops you.")
        self.room:send_except(actor, tostring(actor.name) .. " starts to dance when " .. tostring(self.name) .. " abruptly stops " .. tostring(himher) .. ".")
        actor:send(tostring(self.name) .. " says, 'Woah woah woah " .. tostring(actor.name) .. "!")
        wait(2)
        if shoes then
            actor:send(tostring(self.name) .. " says, 'How in the world do you expect to dance in " .. "%get.obj_shortdesc[%shoes.vnum%]%??'")
        else
            actor:send(tostring(self.name) .. " says, 'How in the world do you expect to dance barefoot??'")
        end
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Put on some proper <b:yellow>dance shoes</>.  If you didn't bring any maybe you can borrow a pair from someone in the company.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Forcibly if you have to.'")
    else
        actor:command("dance")
        actor:advance_quest("bard_subclass")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Well that routine was certainly a... choice.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Last thing, I need to see some of your acting work.  But I suppose you don't have a script yet...'")
        wait(1)
        self:command("think")
        wait(3)
        self:command("snap")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I know someone who had one you might be able to <b:cyan>borrow</>.'")
    end
else
    _return_value = false
end
return _return_value