-- Trigger: academy_revel_command_fill
-- Zone: 519, ID: 63
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51963

-- Converted from DG Script #51963: academy_revel_command_fill
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: fill
if not (cmd == "fill") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "f" or cmd == "fi" then
    _return_value = false
    return _return_value
end
if actor:get_quest_var("school:rest") == 5 then
    actor:set_quest_var("school", "rest", 6)
    actor:command("fill %arg%")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Just like that, perfect!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Now we feast!'")
    wait(2)
    self.room:spawn_object(203, 5)
    self:command("give meat " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Ethilien is filled with edible foods.")
    actor:send("</>You can <b:cyan>EAT</> your way across the world!")
    actor:send("Being full increases your regeneration rate.")
    actor:send("Every time you <b:cyan>EAT</> you also immediately regain some Hit Points!")
    actor:send("Food has no other effects though.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Come, feast with me!  Type <b:green>eat meat</>!'")
    self.room:spawn_object(203, 5)
end
_return_value = false
return _return_value