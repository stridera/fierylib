-- Trigger: shaman pay for training
-- Zone: 30, ID: 171
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #3171

-- Converted from DG Script #3171: shaman pay for training
-- Original: MOB trigger, flags: BRIBE, num_arg: 1 (minimum bribe in copper)

local _return_value = true  -- Default: allow action
local full_skill
if actor:get_quest_var("trainer_3170:word2") then
    if actor:get_quest_var("trainer_3170:skill_name") ~= "sphere" then
        full_skill = tostring(actor:get_quest_var("trainer_3170:skill_name")) .. " of " .. tostring(actor:get_quest_var("trainer_3170:word2"))
    else
        full_skill = tostring(actor:get_quest_var("trainer_3170:skill_name")) .. " " .. tostring(actor:get_quest_var("trainer_3170:word2"))
    end
elseif actor:get_quest_var("trainer_3170:skill_name") then
    full_skill = actor:get_quest_var("trainer_3170:skill_name")
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
        -- Legacy mskillset: the maximum proficiency the trainer quoted (level and class capped).
        skills.set_level(actor, full_skill, actor:get_quest_var("trainer_3170:max_skill") or 1000)
        actor:erase_quest("trainer_3170")
    else
        actor:send(tostring(self.name) .. " says, 'I appreciate your voluntary donation, but I'm afraid that's all it was.'")
        self:command("snicker " .. tostring(actor))
        actor:send("</>")
        actor:send(tostring(self.name) .. " says, 'I don't accept installments.  It's got to be all up front.'")
    end
else
    _return_value = true
    wait(2)
    self:command("consider " .. tostring(actor))
    wait(2)
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Something is different about you.  What skill were you going to train again?'")
    actor:erase_quest("trainer_3170")
end
return _return_value