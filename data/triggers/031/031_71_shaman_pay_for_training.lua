-- Trigger: shaman pay for training
-- Zone: 31, ID: 71
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #3171

-- Converted from DG Script #3171: shaman pay for training
-- Original: MOB trigger, flags: BRIBE, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("trainer_3170:word2") then
    if actor:get_quest_var("trainer_3170:skill_name") ~= sphere then
        local full_skill = actor:get_quest_var("trainer_3170:skill_name") .. " of " .. actor:get_quest_var("trainer_3170:word2")
    else
        local full_skill = actor:get_quest_var("trainer_3170:skill_name") .. " " .. actor:get_quest_var("trainer_3170:word2")
    end
elseif actor:get_quest_var("trainer_3170:skill_name") then
    local full_skill = actor:get_quest_var("trainer_3170:skill_name")
end
wait(1)
if actor:get_quest_var("trainer_3170:actor_level") == actor.level then
    if value >= actor:get_quest_var("trainer_3170:price") then
        self:command("grin " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Fantastic.  Let's get started...'")
        wait(5)
        actor:send("Some time passes...")
        wait(3)
        actor:send("You feel you are getting the hang of things.")
        wait(3)
        actor:send("You feel your skill in " .. tostring(full_skill) .. " improving dramatically!")
        skills.set_level(actor, "%full_skill%", 100)
        actor.name:erase_quest("trainer_3170")
    else
        actor:send(tostring(self.name) .. " says, 'I appreciate your voluntary donation, but I'm afraid that's all it was.'")
        self:command("snicker " .. tostring(actor))
        actor:send("</>")
        actor:send(tostring(self.name) .. " says, 'I don't accept installments.  It's got to be all up front.'")
    end
else
    _return_value = false
    wait(2)
    self:command("consider " .. tostring(actor))
    wait(2)
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Something is different about you.  What skill were you going to train again?'")
    actor.name:erase_quest("trainer_3170")
end
return _return_value