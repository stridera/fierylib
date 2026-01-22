-- Trigger: wizard_eye_seer_greet
-- Zone: 550, ID: 34
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #55034

-- Converted from DG Script #55034: wizard_eye_seer_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
local minlevel = (wandstep - 1) * 10
if actor:get_quest_stage("wizard_eye") == 3 then
    actor:send(tostring(self.name) .. " says, 'I had a feeling you would show up soon.  The shaman from Technitzitlan has sent you to me, yes?'")
    if actor.quest_stage[type_wand] == "wandstep" then
        if actor.level >= minlevel then
            wait(1)
            if actor:get_quest_var("type_wand:greet") == 0 then
                actor:send(tostring(self.name) .. " says, 'Or is there some other reason you're here?'")
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I need for the staff?'")
            end
        end
    end
elseif actor:get_quest_stage("wizard_eye") == 4 then
    actor:send(tostring(self.name) .. " says, 'Do you have the herbs?")
    if actor.quest_stage[type_wand] == "wandstep" then
        if actor.level >= minlevel then
            wait(1)
            if actor:get_quest_var("type_wand:greet") == 0 then
                actor:send(tostring(self.name) .. " says, 'Or is there some other reason you're here?'")
            else
                actor:send(tostring(self.name) .. " says, 'And do you have what I need for the staff?'")
            end
        end
    end
elseif actor.quest_stage[type_wand] == "wandstep" then
    if actor.level >= minlevel then
        if actor:get_quest_var("type_wand:greet") == 0 then
            actor:send(tostring(self.name) .. " says, 'I've been expecting you!  Tell me, what brings you to me?'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the staff?'")
        end
    end
end