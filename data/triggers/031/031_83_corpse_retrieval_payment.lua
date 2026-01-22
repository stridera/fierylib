-- Trigger: corpse retrieval payment
-- Zone: 31, ID: 83
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #3183

-- Converted from DG Script #3183: corpse retrieval payment
-- Original: MOB trigger, flags: BRIBE, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("corpse_retrieval:actor_level") == actor.level then
    if value >= actor:get_quest_var("corpse_retrieval:price") then
        actor:command("consent " .. tostring(self))
        wait(1)
        self:command("nod " .. tostring(actor.name))
        wait(1)
        self:say("That looks right.  Let's get started...")
        wait(1)
        spells.cast(self, "shift corpse", actor.name)
        self.room:send(tostring(self.name) .. " looks exhausted after casting.")
        actor.name:erase_quest("corpse_retrieval")
        actor:command("consent off")
    else
        self.room:send(tostring(self.name) .. " says, 'Thank you for your donation to the Bloody Red Cross, but I'm")
        self.room:send("</>afraid that's all it was.'")
        self:command("snicker " .. tostring(actor))
        -- (empty room echo)
        self:say("I don't accept installments.  It's got to be all up front.")
    end
else
    _return_value = false
    wait(1)
    self:command("consider " .. tostring(actor))
    wait(2)
    self:command("ponder")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Something is different about you.  We have to adjust the spell")
    self.room:send("</>for your new strength.  Do you still want a corpse retrieval?'")
    actor.name:erase_quest("corpse_retrieval")
end
return _return_value